require 'roo'

xlsx = Roo::Spreadsheet.open(Rails.root.join('db', 'seeds', 'goals.xlsx').to_s)

company_id = 2
company = Company.find(company_id)
period = Period.find_by(company_id: company_id, name: "2025")

if period.nil?
  puts "Error: Period '2025' not found for company_id #{company_id}"
  exit
end

header = xlsx.row(1)
# Map header names to column indices
col_map = {
  documento: header.index('Documento'),
  meta_estrategica: header.index('Meta Estratégica'),
  metas: header.index('Metas'),
  descripcion: header.index('Descripción de la Meta'),
  peso: header.index('Peso')
}

# Check if all required columns exist
missing_columns = col_map.select { |k, v| v.nil? }.keys
if missing_columns.any?
  puts "Error: Missing columns in Excel file: #{missing_columns.join(', ')}"
  exit
end

employees_not_found = []
position_goals_created = 0
department_goals_created = 0

(2..xlsx.last_row).each do |i|
  row = xlsx.row(i)
  
  documento = row[col_map[:documento]]
  meta_estrategica = row[col_map[:meta_estrategica]]
  metas = row[col_map[:metas]]
  descripcion = row[col_map[:descripcion]]
  peso = row[col_map[:peso]]
  
  # Skip row if essential data is missing
  next if documento.nil? || meta_estrategica.nil?
  
  # Find employee
  employee = company.employees.find_by(employee_id: documento)
  
  if employee.nil?
    employees_not_found << documento
    next
  end
  
  # Determine goal type based on "Meta Estratégica" column
  if meta_estrategica.to_s.include?("Objetivos Individuales")
    # Create position goal
    PositionGoal.create!(
      goal: metas,
      description: descripcion,
      percentage: peso,
      employee_id: employee.id,
      period_id: period.id,
      position_id: employee.position_id,
      department_id: employee.department_id
    )
    position_goals_created += 1
  else
    # Create department goal
    DepartmentGoal.create!(
      goal: metas,
      description: descripcion,
      percentage: peso,
      employee_id: employee.id,
      period_id: period.id,
      department_id: employee.department_id
    )
    department_goals_created += 1
  end
end

# Summary
puts "=== Goals Import Summary ==="
puts "Position goals created: #{position_goals_created}"
puts "Department goals created: #{department_goals_created}"
puts "Total goals created: #{position_goals_created + department_goals_created}"

if employees_not_found.any?
  puts "\nEmployees not found (#{employees_not_found.count}):"
  employees_not_found.uniq.each do |documento|
    puts "  - Employee ID: #{documento}"
  end
else
  puts "\nAll employees were found successfully!"
end
