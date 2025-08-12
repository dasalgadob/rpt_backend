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
