class CorporativeGoalsController < ApplicationController
  before_action :set_corporative_goal, only: %i[ show update destroy ]

  # GET /corporative_goals
  def index
    @corporative_goals = CorporativeGoal.all

    render json: @corporative_goals
  end

  # GET /corporative_goals/1
  def show
    render json: @corporative_goal
  end

  # POST /corporative_goals
  def create
    @corporative_goal = CorporativeGoal.new(corporative_goal_params)

    if @corporative_goal.save
      render json: @corporative_goal, status: :created, location: @corporative_goal
    else
      render json: @corporative_goal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /corporative_goals/1
  def update
    if @corporative_goal.update(corporative_goal_params)
      render json: @corporative_goal
    else
      render json: @corporative_goal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /corporative_goals/1
  def destroy
    @corporative_goal.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_corporative_goal
      @corporative_goal = CorporativeGoal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def corporative_goal_params
      params.require(:corporative_goal).permit(:period_id, :description, :percentage, :score, :dimension_id)
    end
end
