# == Schema Information
#
# Table name: corporate_goals
#
#  id           :bigint           not null, primary key
#  description  :string
#  percentage   :decimal(5, 2)
#  score        :decimal(5, 2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  dimension_id :bigint           not null
#  period_id    :bigint           not null
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
    
    if total_percentage == 100.0 && all_scores_present
      # Calculate weighted average: (percentage1 * score1 + percentage2 * score2 + ...) / 100
      weighted_sum = corporate_goals.sum { |goal| (goal.percentage * goal.score) }
      weighted_sum / 100.0
    else
      nil
    end
  end
end
