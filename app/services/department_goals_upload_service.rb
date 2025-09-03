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
    (2..sheet.last_row).each do |i|
      employee_name = sheet.cell(i, 'A')&.to_s&.strip
      goal         = sheet.cell(i, 'B')&.to_s&.strip
      description  = sheet.cell(i, 'C')&.to_s&.strip
      percentage   = sheet.cell(i, 'D')
      score        = sheet.cell(i, 'E')
      period_name  = sheet.cell(i, 'F')&.to_s&.strip

      next if employee_name.blank? || period_name.blank?

      employee = company.employees.find_by(name: employee_name)
      unless employee
        skipped << "Empleado '#{employee_name}' not found (row #{i})"
        next
      end
      period = company.periods.find_by(name: period_name)
      unless period
        skipped << "Periodo '#{period_name}' not found (row #{i})"
        next
      end

      attrs = {
        employee_id: employee.id,
        period_id: period.id,
        goal: goal,
        description: description,
        percentage: percentage,
        score: score,
        department_id: employee.department_id
      }

      dg = DepartmentGoal.find_by(employee_id: employee.id, period_id: period.id, goal: goal)
      if dg
        dg.update(attrs)
        @updated += 1
      else
        DepartmentGoal.create(attrs)
        @created += 1
      end
    end
    true
  end
end
