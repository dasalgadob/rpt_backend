class EmployeesController < ApplicationController
  before_action :set_company
  before_action :set_employee, only: %i[ show update destroy ]

  # GET /companies/:company_id/employees
  def index
    # Get employees through company's departments
    department_ids = @company.departments.pluck(:id)
    @employees = Employee.includes(:department, :position_type, :position).where(department_id: department_ids)
    @employees = @employees.where(position_type_id: params[:position_type_id]) if params[:position_type_id].present?
    @employees = @employees.where(position_id: params[:position_id]) if params[:position_id].present?

    # Optionally filter by employee ID
    @employees = @employees.where(employee_id: params[:employee_id]) if params[:employee_id].present?

    # Optionally filter by name
    @employees = @employees.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?

    # Optionally filter by department ID
    @employees = @employees.where(department_id: params[:department_id]) if params[:department_id].present?

    render json: @employees
  end

  # GET /companies/:company_id/employees/1
  def show
    render json: @employee
  end

  # POST /companies/:company_id/employees
  def create
    @employee = Employee.new(employee_params)
    
    # Ensure the department belongs to the company
    department = @company.departments.find(employee_params[:department_id])
    @employee.department = department
    
    # Ensure the position belongs to the company (if provided)
    if employee_params[:position_id].present?
      position = @company.positions.find(employee_params[:position_id])
      @employee.position = position
    end

    if @employee.save
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/employees/1
  def update
    if @employee.update(employee_params)
      render json: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/employees/1
  def destroy
    @employee.destroy!
  end

  # GET /companies/:company_id/employees/download
  def download
    # Get employees through company's departments
    department_ids = @company.departments.pluck(:id)
    @employees = Employee.includes(:department, :position_type, :position).where(department_id: department_ids)

    # Generate Excel file
    package = Axlsx::Package.new
    workbook = package.workbook
    
    workbook.add_worksheet(name: "Empleados") do |sheet|
      # Add header row with Spanish column names
      sheet.add_row [
        "Empleado",
        "Area", 
        "ID empleado",
        "Cargo",
        "Tipo de posicion"
      ]
      
      # Add employee data
      @employees.each do |employee|
        sheet.add_row [
          employee.name,
          employee.department.name,
          employee.employee_id,
          employee.position.name,
          employee.position_type.name
        ]
      end
    end

    # Send the file
    send_data package.to_stream.read,
      filename: "empleados_#{@company.name.parameterize}.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      disposition: 'attachment'
  end

  # POST /companies/:company_id/employees/upload
  def upload
    unless params[:file].present?
      render json: { error: "No file provided" }, status: :unprocessable_entity
      return
    end

    begin
      # Open the uploaded file (auto-detect format)
      spreadsheet = Roo::Spreadsheet.open(params[:file].tempfile)
      
      results = {
        created: 0,
        updated: 0,
        errors: []
      }

      # Process each row (skip header row)
      (2..spreadsheet.last_row).each do |row|
        begin
          # Read row data
          name = spreadsheet.cell(row, 1)&.to_s&.strip
          area_name = spreadsheet.cell(row, 2)&.to_s&.strip
          employee_id = spreadsheet.cell(row, 3)&.to_s&.strip
          position_name = spreadsheet.cell(row, 4)&.to_s&.strip
          position_type_name = spreadsheet.cell(row, 5)&.to_s&.strip

          # Skip empty rows
          next if name.blank? && area_name.blank? && employee_id.blank?

          # Find or create department
          department = @company.departments.find_by(name: area_name)
          if department.nil? && area_name.present?
            department = @company.departments.create!(name: area_name)
          end

          # Find or create position
          position = nil
          if position_name.present?
            position = @company.positions.find_by(name: position_name)
            if position.nil?
              position = @company.positions.create!(name: position_name)
            end
          end

          # Find or create position type
          position_type = nil
          if position_type_name.present?
            position_type = @company.position_types.find_by(name: position_type_name)
            if position_type.nil?
              position_type = @company.position_types.create!(name: position_type_name)
            end
          end

          # Find existing employee by employee_id or create new one
          existing_employee = nil
          if employee_id.present?
            # Find employee through company's departments
            department_ids = @company.departments.pluck(:id)
            existing_employee = Employee.where(department_id: department_ids)
                                      .find_by(employee_id: employee_id)
          end

          if existing_employee
            # Update existing employee
            existing_employee.update!(
              name: name.presence || existing_employee.name,
              department: department || existing_employee.department,
              position: position || existing_employee.position,
              position_type: position_type || existing_employee.position_type
            )
            results[:updated] += 1
          else
            # Create new employee
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

      render json: {
        message: "File processed successfully",
        results: results
      }, status: :ok

    rescue => e
      render json: { error: "Error processing file: #{e.message}" }, status: :unprocessable_entity
    end
  end

  private
    # Set the company from the URL parameter
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      # Ensure the employee belongs to a department in this company
      department_ids = @company.departments.pluck(:id)
      @employee = Employee.includes(:department, :position_type, :position).where(department_id: department_ids).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(:employee_id, :name, :department_id, :position_type_id, :position_id)
    end
end
