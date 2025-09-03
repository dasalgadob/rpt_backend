class EmployeesUploadService
  require 'roo'

  attr_reader :company, :file, :results

  def initialize(company, file)
    @company = company
    @file = file
    @results = { created: 0, updated: 0, errors: [] }
  end

  def process
    return false unless file&.respond_to?(:path) || file&.respond_to?(:tempfile)
    spreadsheet = Roo::Spreadsheet.open(file.respond_to?(:tempfile) ? file.tempfile : file.path)
    (2..spreadsheet.last_row).each do |row|
      begin
        employee_id = spreadsheet.cell(row, 1)&.to_s&.strip
        name = spreadsheet.cell(row, 2)&.to_s&.strip
        position_name = spreadsheet.cell(row, 3)&.to_s&.strip
        area_name = spreadsheet.cell(row, 4)&.to_s&.strip
        position_type_name = spreadsheet.cell(row, 5)&.to_s&.strip

        next if name.blank? && area_name.blank? && employee_id.blank?

        department = company.departments.find_by(name: area_name)
        if department.nil? && area_name.present?
          department = company.departments.create!(name: area_name)
        end

        position = nil
        if position_name.present?
          position = company.positions.find_by(name: position_name)
          if position.nil?
            position = company.positions.create!(name: position_name)
          end
        end

        position_type = nil
        if position_type_name.present?
          position_type = company.position_types.find_by(name: position_type_name)
          if position_type.nil?
            position_type = company.position_types.create!(name: position_type_name)
          end
        end

        existing_employee = nil
        if employee_id.present?
          department_ids = company.departments.pluck(:id)
          existing_employee = Employee.where(department_id: department_ids).find_by(employee_id: employee_id)
        end

        if existing_employee
          existing_employee.update!(
            name: name.presence || existing_employee.name,
            department: department || existing_employee.department,
            position: position || existing_employee.position,
            position_type: position_type || existing_employee.position_type
          )
          results[:updated] += 1
        else
          Employee.create!(
            name: name,
            employee_id: employee_id,
            department: department,
            position: position,
            position_type: position_type
          )
          results[:created] += 1
        end
      rescue => e
        results[:errors] << {
          row: row,
          message: e.message,
          data: {
            name: name,
            area_name: area_name,
            employee_id: employee_id,
            position_name: position_name,
            position_type_name: position_type_name
          }
        }
      end
    end
    true
  end
end
