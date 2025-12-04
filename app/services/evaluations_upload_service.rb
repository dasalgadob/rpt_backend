require 'roo'

class EvaluationsUploadService
  attr_reader :company, :file, :results

  def initialize(company, file)
    @company = company
    @file = file
    @results = {
      updated: 0,
      not_found: 0,
      errors: []
    }
  end

  def process
    return false unless file.present?

    begin
      # Determine file type and open with Roo
      spreadsheet = case File.extname(file.original_filename)
                   when ".xlsx"
                     Roo::Excelx.new(file.path)
                   when ".xls"
                     Roo::Excel.new(file.path)
                   when ".csv"
                     Roo::CSV.new(file.path)
                   else
                     return false
                   end

      process_spreadsheet(spreadsheet)
      true
    rescue => e
      Rails.logger.error("Error processing file: #{e.message}")
      false
    end
  end

  private

  def process_spreadsheet(spreadsheet)
    # Skip header row and process data rows
    (2..spreadsheet.last_row).each do |row|
      begin
        # Read data from Excel columns
        employee_id = spreadsheet.cell(row, 1)&.to_s&.strip  # ID column
        job_competencies_score = spreadsheet.cell(row, find_competencias_column(spreadsheet))&.to_f  # Puntuación competencias column

        # Skip if essential data is missing
        next if employee_id.blank? || job_competencies_score.nil?

        # Find employee evaluation by company and employee_id
        employee_evaluation = find_employee_evaluation(employee_id)

        if employee_evaluation
          # Update job_competencies_score
          if employee_evaluation.update(job_competencies_score: job_competencies_score)
            results[:updated] += 1
          else
            results[:errors] << {
              row: row,
              employee_id: employee_id,
              message: employee_evaluation.errors.full_messages.join(', ')
            }
          end
        else
          results[:not_found] += 1
          results[:errors] << {
            row: row,
            employee_id: employee_id,
            message: "Employee evaluation not found for employee ID: #{employee_id}"
          }
        end

      rescue => e
        results[:errors] << {
          row: row,
          employee_id: employee_id,
          message: "Error processing row: #{e.message}"
        }
      end
    end
  end

  def find_competencias_column(spreadsheet)
    # Find the column index for "Puntuación competencias"
    header_row = 1
    (1..spreadsheet.last_column).each do |col|
      header_value = spreadsheet.cell(header_row, col)&.to_s&.strip&.downcase
      if header_value&.include?("puntuación competencias") || 
         header_value&.include?("puntuacion competencias")
        return col
      end
    end
    
    # Default to a common column if not found (you can adjust this)
    # Assuming it might be in a standard position
    raise "Could not find 'Puntuación competencias' column in the Excel file"
  end

  def find_employee_evaluation(employee_id)
    # Get company's department IDs
    department_ids = company.departments.pluck(:id)
    
    # Find employee by employee_id within company departments
    employee = Employee.joins(:department)
                      .where(employee_id: employee_id, department_id: department_ids)
                      .first
    
    return nil unless employee

    # Find the employee evaluation for the open period
    open_period = company.periods.find_by(status: 'abierto')
    return nil unless open_period

    # Find the employee evaluation
    EmployeeEvaluation.find_by(employee: employee, period: open_period)
  end
end