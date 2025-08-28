class PositionGoalsController < ApplicationController
  before_action :set_company
  before_action :set_position_goal, only: %i[ show update destroy ]

  # GET /companies/:company_id/position_goals
  def index
    # Get position goals through company's positions
    position_ids = @company.positions.pluck(:id)
    @position_goals = PositionGoal.includes(:position, :period, :department).where(position_id: position_ids)
    @position_goals = @position_goals.where(period_id: params[:period_id]) if params[:period_id].present?
    @position_goals = @position_goals.where(department_id: params[:department_id]) if params[:department_id].present?
    @position_goals = @position_goals.where(position_id: params[:position_id]) if params[:position_id].present?
    @position_goals = @position_goals.for_employee(params[:employee_id]) if params[:employee_id].present?

    render json: @position_goals
  end

  # GET /companies/:company_id/position_goals/1
  def show
    render json: @position_goal
  end

  # POST /companies/:company_id/position_goals
  def create
    @position_goal = PositionGoal.new(position_goal_params)
    
    # Ensure the position belongs to the company
    position = @company.positions.find(position_goal_params[:position_id])
    @position_goal.position = position

    if @position_goal.save
      render json: @position_goal, status: :created
    else
      render json: @position_goal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/position_goals/1
  def update
    if @position_goal.update(position_goal_params)
      render json: @position_goal
    else
      render json: @position_goal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/position_goals/1
  def destroy
    @position_goal.destroy!
  end

  private
    # Set the company from the URL parameter
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_position_goal
      # Ensure the position goal belongs to a position in this company
      position_ids = @company.positions.pluck(:id)
      @position_goal = PositionGoal.includes(:position, :period).where(position_id: position_ids).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def position_goal_params
      params.require(:position_goal).permit(:position_id, :period_id, :description, :percentage, :score, :department_id, :employee_id)
    end
end
