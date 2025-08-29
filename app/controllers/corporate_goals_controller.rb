class CorporateGoalsController < ApplicationController
  before_action :set_corporate_goal, only: %i[ show update destroy ]

  # GET /corporate_goals
  def index
    @corporate_goals = CorporateGoal.includes(:dimension, :period).where(period_id: params[:period_id])

    # Calculate total_score based on conditions
    total_score = nil
    
    if @corporate_goals.any?
      # Check if sum of percentages equals 100%
      total_percentage = @corporate_goals.sum(&:percentage)
      
      # Check if all scores have values (not null)
      all_scores_present = @corporate_goals.all? { |goal| goal.score.present? }
      
      if total_percentage == 100.0 && all_scores_present
        # Calculate weighted average: (percentage1 * score1 + percentage2 * score2 + ...) / 100
        weighted_sum = @corporate_goals.sum { |goal| (goal.percentage * goal.score) }
        total_score = weighted_sum / 100.0
      end
    end

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@corporate_goals, each_serializer: CorporateGoalSerializer).as_json[:data],
      total_score: total_score&.to_f,
      total_percentage: @corporate_goals.sum(&:percentage).to_f
    }
  end

  # GET /corporate_goals/1
  def show
    render json: @corporate_goal
  end

  # POST /corporate_goals
  def create
    @corporate_goal = CorporateGoal.new(corporate_goal_params)

    if @corporate_goal.save
      render json: @corporate_goal, status: :created
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
      params.require(:corporate_goal).permit(:period_id, :description, :percentage, :score, :dimension_id, :goal)
    end
end
