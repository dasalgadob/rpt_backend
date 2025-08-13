class DepartmentGoalsController < ApplicationController
  before_action :set_department_goal, only: %i[ show update destroy ]

  # GET /department_goals
  def index
    @department_goals = DepartmentGoal.includes(:department, :period)
    @department_goals = @department_goals.where(period_id: params[:period_id]) if params[:period_id].present?
    @department_goals = @department_goals.where(department_id: params[:department_id]) if params[:department_id].present?

    render json: @department_goals
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department_goal
      @department_goal = DepartmentGoal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def department_goal_params
      params.require(:department_goal).permit(:department_id, :period_id, :description, :percentage, :score)
    end
end
