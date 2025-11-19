# == Schema Information
#
# Table name: corporate_goals
#
#  id                  :bigint           not null, primary key
#  adjustment_factor   :decimal(10, 2)
#  curvature           :decimal(10, 2)
#  curvature2          :decimal(10, 2)
#  description         :string
#  formula_above_value :text
#  formula_below_value :text
#  goal                :text
#  goal_achieved       :decimal(, )
#  goal_ceil           :decimal(, )
#  goal_floor          :decimal(, )
#  goal_value          :decimal(, )
#  inferior_limit      :decimal(10, 2)
#  percentage          :decimal(5, 2)
#  score               :decimal(5, 2)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  dimension_id        :bigint           not null
#  period_id           :bigint           not null
#
# Indexes
#
#  index_corporate_goals_on_dimension_id  (dimension_id)
#  index_corporate_goals_on_period_id     (period_id)
#
# Foreign Keys
#
#  fk_rails_...  (dimension_id => dimensions.id)
#  fk_rails_...  (period_id => periods.id)
#
class CorporateGoal < ApplicationRecord
  belongs_to :period
  belongs_to :dimension

  # Calculate corporate score for a company and period
  # Returns the weighted average score if percentages sum to 100% and all scores are present
  def self.corporate_score_for_period(company, period = nil)
    # Use open period if none provided
    period ||= company.periods.find_by(status: 'abierto')
    return nil unless period

    # Get all corporate goals for this period
    corporate_goals = CorporateGoal.where(period: period)
    return nil unless corporate_goals.any?

    # Check if sum of percentages equals 100%
    total_percentage = corporate_goals.sum(:percentage)
    
    # Check if all scores have values (not null)
    all_scores_present = corporate_goals.all? { |goal| goal.score.present? }
    
    if (total_percentage - 100.0).abs <= 0.01 && all_scores_present
      # Calculate weighted average: (percentage1 * score1 + percentage2 * score2 + ...) / 100
      weighted_sum = corporate_goals.sum { |goal| (goal.percentage * goal.score) }
      weighted_sum / 100.0
    else
      nil
    end
  end

  def calculate_goal_result
    return 0 if goal_achieved.nil? || goal_floor.nil? || goal_value.nil?
    result = 0 
    x = goal_achieved
    if x >= goal_floor && x <= goal_value
      result = (eval("#{formula_below_value}") * 100)&.to_f
    elsif x > goal_value && x <= goal_ceil
      result = (eval("#{formula_above_value}") * 100)&.to_f
    end
    if result > 110.0
      result = 110.0
    end
    result
  end

  def score
    calculate_goal_result
  end

  def self.total_score(period_id)
      @corporate_goals = CorporateGoal.includes(:dimension, :period).where(period_id: period_id)
      total_percentage = @corporate_goals.sum(&:percentage)
      total_score = 0
      all_scores_present = @corporate_goals.all? { |goal| goal.score.present? }
      if (total_percentage - 100.0).abs <= 0.01 && all_scores_present
        # Calculate weighted average: (percentage1 * score1 + percentage2 * score2 + ...) / 100
        weighted_sum = @corporate_goals.sum { |goal| (goal.percentage * goal.score) }
        total_score = weighted_sum / 100.0
      end
      total_score
  end
end
