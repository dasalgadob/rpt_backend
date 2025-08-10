class CorporateGoalsController < ApplicationController
  before_action :set_corporate_goal, only: %i[ show update destroy ]

  # GET /corporate_goals
  def index
    @corporate_goals = CorporateGoal.all

    render json: @corporate_goals
  end

  # GET /corporate_goals/1
  def show
    render json: @corporate_goal
  end

  # POST /corporate_goals
  def create
    @corporate_goal = CorporateGoal.new(corporate_goal_params)

    if @corporate_goal.save
      render json: @corporate_goal, status: :created, location: @corporate_goal
    else
      render json: @corporate_goal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /corporate_goals/1
  def update
    if @corporate_goal.update(corporate_goal_params)
      render json: @corporate_goal
    else
      render json: @corporate_goal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /corporate_goals/1
  def destroy
    @corporate_goal.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_corporate_goal
      @corporate_goal = CorporateGoal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def corporate_goal_params
      params.require(:corporate_goal).permit(:period_id, :description, :percentage, :score, :dimension_id)
    end
end
