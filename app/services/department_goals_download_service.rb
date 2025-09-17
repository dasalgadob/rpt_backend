class DepartmentGoalsDownloadService
  def initialize(company, period_id = nil)
    @company = company
    @period_id = period_id
  end

  def generate_excel
    department_goals = fetch_department_goals
    generate_excel_data(department_goals)
  end

  def filename
    "department_goals_#{@company.name.parameterize}_#{Date.current.strftime('%Y%m%d')}.xlsx"
  end

  private

  def fetch_department_goals
    department_ids = @company.departments.pluck(:id)
    employees = Employee.includes(:department, :position_type, :position).where(department_id: department_ids)
    employee_ids = employees.pluck(:id)
    
    department_goals = DepartmentGoal.joins(:employee, :period)
                                   .includes(:employee, :period)
                                   .where(employee_id: employee_ids)
                                   .order('employees.employee_id, periods.name')

    # Filter by period if specified
    department_goals = department_goals.where(period_id: @period_id) if @period_id.present?
    
    department_goals
  end

  def generate_excel_data(department_goals)
    require 'caxlsx'
    
    package = Axlsx::Package.new
    workbook = package.workbook
    
    workbook.add_worksheet(name: "Metas Departamentales") do |sheet|
      # Add headers
      headers = [
        "ID Empleado", 
        "Empleado", 
        "Meta", 
        "Descripcion", 
        "Porcentaje", 
        "Evaluacion", 
        "Periodo"
      ]
      sheet.add_row headers, style: workbook.styles.add_style(b: true)
      
      # Add data rows
      department_goals.each do |goal|
        sheet.add_row [
          goal.employee&.employee_id,
          goal.employee&.name,
          goal.goal,
          goal.description,
          goal.percentage&.to_f,
          goal.score&.to_f,
          goal.period&.name
        ]
      end
      
      # Auto-size columns
      sheet.column_widths 15, 25, 30, 40, 12, 12, 15
    end
    
    package.to_stream.read
  end
end
