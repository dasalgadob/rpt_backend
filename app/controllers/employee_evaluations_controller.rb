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
      company_employees = Employee.includes(:position, position_type: :position_type_weights).where(department_id: department_ids)

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
          job_competencies_percentage: position_type_weight.job_competencies_percentage, # Added job competencies percentage
          evaluation_score: nil
        )
      end
    end
    
    # Determine which period to use for evaluations
    # If period_id is given, use that period; otherwise use open period
    target_period = if params[:period_id].present?
                      @company.periods.find_by(id: params[:period_id])
                    else
                      open_period
                    end

    # Get employee evaluations for the target period only
    # Use specific department if provided, otherwise use all company departments
    department_ids = if params[:department_id].present?
                       [params[:department_id].to_i]
                     else
                       @company.departments.pluck(:id)
                     end
    
    # Build employee query with department and position filtering
    employee_query = Employee.where(department_id: department_ids)
    employee_query = employee_query.where(position_id: params[:position_id]) if params[:position_id].present?
    employee_query = employee_query.where(position_type_id: params[:position_type_id]) if params[:position_type_id].present?
    # Get the filtered employee IDs
    employee_ids = employee_query.pluck(:id)
    
    if target_period
      @employee_evaluations = EmployeeEvaluation.includes(
        :period, 
        employee: [:department, :position, :position_type, { position_type: :position_type_weights }]
      ).where(employee_id: employee_ids, period: target_period)
    else
      @employee_evaluations = EmployeeEvaluation.none
    end

    # Add filtering by name if provided
    if params[:name].present?
      @employee_evaluations = @employee_evaluations.joins(:employee).where("employees.name ILIKE ?", "%#{params[:name]}%")
    end
    
    # Add filtering by employee if provided
    if params[:employee_id].present?
      @employee_evaluations = @employee_evaluations.where(employee_id: params[:employee_id])
    end

    # Use the same target period for corporate score calculation
    score_period = target_period
    
    # Only calculate corporate score if we have a valid target period
    corporate_score = if target_period
                        CorporateGoal.corporate_score_for_period(@company, score_period)
                      else
                        nil
                      end

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(
        @employee_evaluations, 
        each_serializer: EmployeeEvaluationSerializer,
        scope: { 
          corporate_score: corporate_score,
          target_period: target_period,
          company: @company
        }
      ).as_json[:data],
      corporate_score: corporate_score&.to_f
    }
  end

  # GET /companies/:company_id/employee_evaluations/1
  def show
    # Calculate corporate score for the evaluation's period
    evaluation_corporate_score = CorporateGoal.corporate_score_for_period(@company, @employee_evaluation.period)
    
    render json: @employee_evaluation, 
           serializer: EmployeeEvaluationSerializer, 
           scope: { 
             corporate_score: evaluation_corporate_score,
             target_period: @employee_evaluation.period,
             company: @company
           }
  end

  # POST /companies/:company_id/employee_evaluations
  def create
    @employee_evaluation = EmployeeEvaluation.new(employee_evaluation_params)
    
    # Ensure the employee belongs to this company
    department_ids = @company.departments.pluck(:id)
    employee_ids = Employee.where(department_id: department_ids).pluck(:id)
    
    unless employee_ids.include?(@employee_evaluation.employee_id)
      render json: { error: 'Employee does not belong to this company' }, status: :unprocessable_entity
      return
    end

    if @employee_evaluation.save
      @employee_evaluation = EmployeeEvaluation.includes(
        :period, 
        employee: [:department, :position, :position_type, { position_type: :position_type_weights }]
      ).find(@employee_evaluation.id)
      
      # Calculate corporate score for the evaluation's period
      evaluation_corporate_score = CorporateGoal.corporate_score_for_period(@company, @employee_evaluation.period)
      
      render json: @employee_evaluation, 
             serializer: EmployeeEvaluationSerializer, 
             scope: { 
               corporate_score: evaluation_corporate_score,
               target_period: @employee_evaluation.period,
               company: @company
             },
             status: :created
    else
      render json: @employee_evaluation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/employee_evaluations/1
  def update
    if @employee_evaluation.update(employee_evaluation_params)
      # Calculate corporate score for the evaluation's period
      evaluation_corporate_score = CorporateGoal.corporate_score_for_period(@company, @employee_evaluation.period)
      
      render json: @employee_evaluation, 
             serializer: EmployeeEvaluationSerializer,
             scope: { 
               corporate_score: evaluation_corporate_score,
               target_period: @employee_evaluation.period,
               company: @company
             }
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
        job_competencies_percentage: position_type_weight.job_competencies_percentage,
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

  # GET /companies/:company_id/employee_evaluations/download
  def download
    # Determine which period to use for evaluations
    target_period = if params[:period_id].present?
                      @company.periods.find_by(id: params[:period_id])
                    else
                      @company.periods.find_by(status: 'abierto')
                    end

    unless target_period
      render json: { error: 'No period found' }, status: :unprocessable_entity
      return
    end

    # Get employee evaluations for the target period with same filtering logic as index
    department_ids = if params[:department_id].present?
                       [params[:department_id].to_i]
                     else
                       @company.departments.pluck(:id)
                     end
    
    # Build employee query with department and position filtering
    employee_query = Employee.where(department_id: department_ids)
    employee_query = employee_query.where(position_id: params[:position_id]) if params[:position_id].present?
    employee_query = employee_query.where(position_type_id: params[:position_type_id]) if params[:position_type_id].present?
    employee_ids = employee_query.pluck(:id)

    @employee_evaluations = EmployeeEvaluation.includes(
      :period, 
      employee: [:department, :position, :position_type, { position_type: :position_type_weights }]
    ).where(employee_id: employee_ids, period: target_period)

    # Add filtering by name if provided
    if params[:name].present?
      @employee_evaluations = @employee_evaluations.joins(:employee).where("employees.name ILIKE ?", "%#{params[:name]}%")
    end
    
    # Add filtering by employee if provided
    if params[:employee_id].present?
      @employee_evaluations = @employee_evaluations.where(employee_id: params[:employee_id])
    end

    # Calculate corporate score for the period
    corporate_score = CorporateGoal.corporate_score_for_period(@company, target_period)

    # Generate Excel file
    excel_data = EmployeeEvaluationsDownloadService.new(@employee_evaluations, @company, corporate_score).call
    
    # Send file
    send_data excel_data,
              filename: "employee_evaluations_#{@company.name.parameterize}_#{target_period.name.parameterize}_#{Date.current.strftime('%Y%m%d')}.xlsx",
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end

  private
    # Set the parent company
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_employee_evaluation
      # Get company employee IDs first
      department_ids = @company.departments.pluck(:id)
      employee_ids = Employee.where(department_id: department_ids).pluck(:id)
      
      @employee_evaluation = EmployeeEvaluation.includes(
        :period, 
        employee: [:department, :position, :position_type, { position_type: :position_type_weights }]
      ).find_by(id: params[:id], employee_id: employee_ids)
      
      unless @employee_evaluation
        render json: { error: 'Employee evaluation not found' }, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def employee_evaluation_params
      params.require(:employee_evaluation).permit(:employee_id, :period_id, :evaluation_score, :corporate_percentage, :department_percentage, :position_percentage, :job_competencies_score)
    end
end
