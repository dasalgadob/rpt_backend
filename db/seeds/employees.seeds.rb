require 'roo'

xlsx = Roo::Spreadsheet.open(Rails.root.join('db', 'seeds', 'employees.xlsx').to_s)

company_id = 2

header = xlsx.row(1)
# Map header names to column indices
col_map = {
  employee_id: header.index('Documento') + 1,
  name: header.index('Empleado') + 1,
  area: header.index('Area') + 1,
  cargo: header.index('Cargo') + 1
}

(2..xlsx.last_row).each do |i|
  row = xlsx.row(i)
  employee_id = row[col_map[:employee_id] - 1]
  name = row[col_map[:name] - 1]
  area = row[col_map[:area] - 1]
  cargo = row[col_map[:cargo] - 1]

  # Find or create department
  department = Department.find_or_create_by!(company_id: company_id, name: area)

  # Find or create position
  position = Position.find_or_create_by!(company_id: company_id, name: cargo)

  # Create employee
  Employee.create!(
    employee_id: employee_id,
    name: name,
    department_id: department.id,
    position_id: position.id
  )
end