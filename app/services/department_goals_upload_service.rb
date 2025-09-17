class DepartmentGoalsUploadService
  require 'roo'

  attr_reader :company, :file, :created, :updated, :skipped

  def initialize(company, file)
    @company = company
    @file = file
    @created = 0
    @updated = 0
    @skipped = []
  end

  def process
    return false unless file&.respond_to?(:path)
    xlsx = Roo::Spreadsheet.open(file.path)
    sheet = xlsx.sheet(0)
    
    # Map headers to column indices
    header = sheet.row(1)
    col_map = {
      employee_id: header.index('ID Empleado'),
      employee_name: header.index('Empleado'),
      goal: header.index('Meta'),
      description: header.index('Descripcion'),
      percentage: header.index('Porcentaje'),
      score: header.index('Evaluacion'),
      period_name: header.index('Periodo')
    }
    
    (2..sheet.last_row).each do |i|
      employee_id  = sheet.cell(i, col_map[:employee_id] + 1)&.to_s&.strip
      goal         = sheet.cell(i, col_map[:goal] + 1)&.to_s&.strip
      description  = sheet.cell(i, col_map[:description] + 1)&.to_s&.strip
      percentage   = sheet.cell(i, col_map[:percentage] + 1)
      score        = sheet.cell(i, col_map[:score] + 1)
      period_name  = sheet.cell(i, col_map[:period_name] + 1)&.to_s&.strip

      next if employee_id.blank? || period_name.blank?

      employee = company.employees.find_by(employee_id: employee_id)
      unless employee
        skipped << "Empleado ID '#{employee_id}' not found (row #{i})"
        next
      end
      
      period = company.periods.find_by(name: period_name)
      unless period
        skipped << "Periodo '#{period_name}' not found (row #{i})"
        next
      end

      # Search by goal and employee for existing record
      dg = DepartmentGoal.find_by(employee_id: employee.id, goal: goal)
      
      if dg
        # Update existing record
        dg.update!(
          description: description,
          percentage: percentage,
          score: score,
          period_id: period.id
        )
        @updated += 1
      else
        # Create new record
        DepartmentGoal.create!(
          employee_id: employee.id,
          period_id: period.id,
          goal: goal,
          description: description,
          percentage: percentage,
          score: score,
          department_id: employee.department_id
        )
        @created += 1
      end
    end
    true
  end
end
