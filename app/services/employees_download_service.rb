class EmployeesDownloadService
  def initialize(company)
    @company = company
  end

  def generate_excel
    employees = fetch_employees
    generate_excel_data(employees)
  end

  def filename
    "empleados_#{@company.name.parameterize}.xlsx"
  end

  private

  def fetch_employees
    department_ids = @company.departments.pluck(:id)
    Employee.includes(:department, :position_type, :position).where(department_id: department_ids)
  end

  def generate_excel_data(employees)
    require 'caxlsx'
    
    package = Axlsx::Package.new
    workbook = package.workbook
    
    workbook.add_worksheet(name: "Empleados") do |sheet|
      # Add header row with Spanish column names
      headers = [
        "ID empleado",
        "Empleado",
        "Salario",
        "Base 110",
        "Area", 
        "Cargo",
        "Tipo de posicion"
      ]
      sheet.add_row headers, style: workbook.styles.add_style(b: true)
      
      # Add employee data
      employees.each do |employee|
        sheet.add_row [
          employee.employee_id,
          employee.name,
          employee.salary&.to_f&.round(2),
          employee.is_base_110 ? "Si" : "No",
          employee.department&.name,
          employee.position&.name,
          employee.position_type&.name
        ]
      end
      
      # Auto-size columns
      sheet.column_widths 15, 25, 15, 10, 20, 25, 20
    end
    
    package.to_stream.read
  end
end
