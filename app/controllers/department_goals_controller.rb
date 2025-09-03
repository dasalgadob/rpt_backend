class DepartmentGoalsController < ApplicationController
  before_action :set_department_goal, only: %i[ show update destroy ]

  # GET /department_goals
  def index
    @department_goals = DepartmentGoal.includes(:department, :period)
    @department_goals = @department_goals.where(period_id: params[:period_id]) if params[:period_id].present?
    @department_goals = @department_goals.for_department(params[:department_id]) if params[:department_id].present?
    @department_goals = @department_goals.for_employee(params[:employee_id]) if params[:employee_id].present?

    # Calculate department percentage analysis
    departments_ok_count = 0
    departments_error = []
    total_departments = 0
    total_percentage = nil
    total_score = nil

    # If filtering by specific department, calculate its total percentage and score
    if params[:department_id].present?
      total_percentage = @department_goals.sum(&:percentage).to_f
      
      # Calculate total_score only if percentage equals 100% and all scores are present
      if total_percentage == 100.0 && @department_goals.all? { |goal| goal.score.present? }
        weighted_sum = @department_goals.sum { |goal| (goal.percentage * goal.score) }
        total_score = (weighted_sum / 100.0).to_f
      end
    end

    if params[:period_id].present? && params[:department_id].blank?
      # Group goals by department for the specific period
      goals_by_department = @department_goals.group_by(&:department)
      
      # Get all departments that belong to the company (from the nested route)
      company = Company.find(params[:company_id]) if params[:company_id].present?
      all_departments = company.departments
      total_departments = all_departments.count
      
      all_departments.each do |department|
        department_goals = goals_by_department[department] || []
        department_total_percentage = department_goals.sum(&:percentage)
        
        if department_total_percentage == 100.0
          departments_ok_count += 1
        else
          departments_error << department.name
        end
      end
    end

    # Build response data
    response_data = {
      data: ActiveModelSerializers::SerializableResource.new(@department_goals, each_serializer: DepartmentGoalSerializer).as_json[:data]
    }

    # Add departments analysis when no department filter is applied
    if params[:department_id].blank?
      departments_ok_message = "#{departments_ok_count}/#{total_departments} Areas tienen sus porcentajes definidos al 100%"
      departments_error_message = departments_error.any? ? 
        "Las siguientes Areas deben corregirse para sumar el 100%: #{departments_error.join(', ')}" : 
        nil
      
      response_data[:departments_ok] = departments_ok_message
      response_data[:departments_error] = departments_error_message
    end

    # Add total_percentage and total_score when filtering by department
    if params[:department_id].present?
      response_data[:total_percentage] = total_percentage
      response_data[:total_score] = total_score
    end

    render json: response_data
  end

  # GET /department_goals/1
  def show
    render json: @department_goal
  end

  # POST /department_goals
  def create
    @department_goal = DepartmentGoal.new(department_goal_params)

    if @department_goal.save
      render json: @department_goal, status: :created
    else
      render json: @department_goal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /department_goals/1
  def update
    if @department_goal.update(department_goal_params)
      render json: @department_goal
    else
      render json: @department_goal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /department_goals/1
  def destroy
    @department_goal.destroy!
  end

  def upload
    company = Company.find(params[:company_id])
    service = DepartmentGoalsUploadService.new(company, params[:file])
    if !service.process
      render json: { error: 'No file uploaded' }, status: :bad_request and return
    end
    render json: { created: service.created, updated: service.updated, skipped: service.skipped }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department_goal
      @department_goal = DepartmentGoal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def department_goal_params
      params.require(:department_goal).permit(:employee_id, :period_id, :description, :percentage, :score, :department_id, :goal)
    end
end
