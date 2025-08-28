class DepartmentsController < ApplicationController
  before_action :set_company
  before_action :set_department, only: %i[ show update destroy ]

  # GET /companies/:company_id/departments
  def index
    @departments = @company.departments

    render json: @departments
  end

  # GET /companies/:company_id/departments/1
  def show
    render json: @department
  end

  # POST /companies/:company_id/departments
  def create
    @department = @company.departments.new(department_params)

    if @department.save
      render json: @department, status: :created
    else
      render json: @department.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/departments/1
  def update
    if @department.update(department_params)
      render json: @department
    else
      render json: @department.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/departments/1
  def destroy
    @department.destroy!
  end

  require 'axlsx'

  # GET /companies/:company_id/departments/download
  def download
    departments = @company.departments.select(:id, :name)
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.add_worksheet(name: "Areas") do |sheet|
      sheet.add_row ["ID", "Nombre"]
      departments.each do |dept|
        sheet.add_row [dept.id, dept.name]
      end
    end
    file_name = "Areas#{@company.name}.xlsx"
    send_data package.to_stream.read, filename: file_name, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  require 'roo'

  # POST /companies/:company_id/departments/upload
  def upload
    file = params[:file]
    unless file&.respond_to?(:path)
      render json: { error: 'No file uploaded' }, status: :bad_request and return
    end
    xlsx = Roo::Spreadsheet.open(file.path)
    sheet = xlsx.sheet(0)
    errors = []
    (2..sheet.last_row).each do |i|
      id = sheet.cell(i, 1)
      name = sheet.cell(i, 2)
      next unless name.present?
      if id.present?
        department = @company.departments.find_by(id: id)
        if department
          if department.name != name
            department.update(name: name)
          end
        else
          errors << "Department with ID #{id} not found."
        end
      else
        @company.departments.create(name: name)
      end
    end
    if errors.any?
      render json: { message: 'Upload completed with some errors', errors: errors }, status: :multi_status
    else
      render json: { message: 'Upload successful' }, status: :ok
    end
  end

  private
    # Set the company from the URL parameter
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = @company.departments.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def department_params
      params.require(:department).permit(:name)
    end
end
