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
    @employees = @employees.where(id: params[:employee_id]) if params[:employee_id].present?

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
    service = EmployeesDownloadService.new(@company)
    excel_data = service.generate_excel
    
    send_data excel_data,
      filename: service.filename,
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
      service = EmployeesUploadService.new(@company, params[:file])
      unless service.process
        render json: { error: "No file provided or invalid file" }, status: :unprocessable_entity
        return
      end
      render json: {
        message: "File processed successfully",
        results: service.results
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
      params.require(:employee).permit(:employee_id, :name, :salary, :is_base_110, :department_id, :position_type_id, :position_id)
    end
end
