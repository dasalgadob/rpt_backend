class EmployeeEvaluationsController < ApplicationController
  before_action :set_company
  before_action :set_employee_evaluation, only: %i[ show update destroy ]

  # GET /companies/:company_id/employee_evaluations
  def index
    # Find the open period for this company
    open_period = @company.periods.find_by(status: 'abierto')
    
    if open_period
      # Get company employees
      department_ids = @company.departments.pluck(:id)
      company_employees = Employee.includes(:position, :position_type).where(department_id: department_ids)
      
      # Find employees without evaluations for the open period
      existing_evaluation_employee_ids = EmployeeEvaluation.where(
        employee_id: company_employees.pluck(:id),
        period: open_period
      ).pluck(:employee_id)
      
      employees_without_evaluations = company_employees.where.not(id: existing_evaluation_employee_ids)
      
      # Create evaluations for employees without them
      employees_without_evaluations.each do |employee|
        position_type = employee.position_type
        
        next unless position_type
        
        # Find position type weight for this period and position type
        position_type_weight = PositionTypeWeight.find_by(
          period: open_period,
          position_type: position_type
        )
        
        next unless position_type_weight
        
        # Create employee evaluation with percentages from position type weight
        EmployeeEvaluation.create!(
          employee: employee,
          period: open_period,
          corporate_percentage: position_type_weight.corporate_percentage,
          department_percentage: position_type_weight.department_percentage,
          position_percentage: position_type_weight.position_percentage,
          evaluation_score: nil
        )
      end
    end
    
    # Get employee evaluations through company's employees
    department_ids = @company.departments.pluck(:id)
    employee_ids = Employee.where(department_id: department_ids).pluck(:id)
    @employee_evaluations = EmployeeEvaluation.includes(:employee, :period).where(employee_id: employee_ids)
    
    # Add filtering by name if provided
    if params[:name].present?
      @employee_evaluations = @employee_evaluations.joins(:employee).where("employees.name ILIKE ?", "%#{params[:name]}%")
    end
    
    # Add filtering by period if provided
    if params[:period_id].present?
      @employee_evaluations = @employee_evaluations.where(period_id: params[:period_id])
    end
    
    # Add filtering by employee if provided
    if params[:employee_id].present?
      @employee_evaluations = @employee_evaluations.where(employee_id: params[:employee_id])
    end

    render json: @employee_evaluations
  end

  # GET /companies/:company_id/employee_evaluations/1
  def show
    render json: @employee_evaluation
  end

  # POST /companies/:company_id/employee_evaluations
  def create
    @employee_evaluation = @company.employee_evaluations.new(employee_evaluation_params)

    if @employee_evaluation.save
      render json: @employee_evaluation, status: :created, location: [@company, @employee_evaluation]
    else
      render json: @employee_evaluation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/employee_evaluations/1
  def update
    if @employee_evaluation.update(employee_evaluation_params)
      render json: @employee_evaluation
    else
      render json: @employee_evaluation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/employee_evaluations/1
  def destroy
    @employee_evaluation.destroy!
  end

  # POST /companies/:company_id/employee_evaluations/create_batch_employee_evaluations
  def create_batch_employee_evaluations
    open_period = @company.periods.find_by(status: 'abierto')
    
    unless open_period
      render json: { error: 'No open period found for this company' }, status: :unprocessable_entity
      return
    end

    created_evaluations = []
    errors = []

    @company.employees.includes(position: :position_type).each do |employee|
      position_type = employee.position&.position_type
      
      unless position_type
        errors << "Employee #{employee.id} has no position or position type"
        next
      end

      # Find position type weight for this period and position type
      position_type_weight = PositionTypeWeight.find_by(
        period: open_period,
        position_type: position_type
      )

      unless position_type_weight
        errors << "No position type weight found for employee #{employee.id} (position type: #{position_type.name})"
        next
      end

      # Check if evaluation already exists
      existing_evaluation = EmployeeEvaluation.find_by(
        employee: employee,
        period: open_period
      )

      if existing_evaluation
        errors << "Evaluation already exists for employee #{employee.id} in this period"
        next
      end

      # Create employee evaluation with percentages from position type weight
      evaluation = EmployeeEvaluation.new(
        employee: employee,
        period: open_period,
        corporate_percentage: position_type_weight.corporate_percentage,
        department_percentage: position_type_weight.department_percentage,
        position_percentage: position_type_weight.position_percentage,
        evaluation_score: nil # Will be filled later
      )

      if evaluation.save
        created_evaluations << evaluation
      else
        errors << "Failed to create evaluation for employee #{employee.id}: #{evaluation.errors.full_messages.join(', ')}"
      end
    end

    render json: {
      message: "Batch creation completed",
      created_count: created_evaluations.count,
      errors: errors,
      created_evaluations: created_evaluations
    }, status: :created
  end

  private
    # Set the parent company
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_employee_evaluation
      @employee_evaluation = @company.employee_evaluations.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_evaluation_params
      params.require(:employee_evaluation).permit(:employee_id, :period_id, :evaluation_score, :corporate_percentage, :department_percentage, :position_percentage)
    end
end
