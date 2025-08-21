# == Schema Information
#
# Table name: position_goals
#
#  id            :bigint           not null, primary key
#  description   :string
#  percentage    :decimal(5, 2)
#  score         :decimal(5, 2)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :bigint           not null
#  employee_id   :bigint
#  period_id     :bigint           not null
#  position_id   :bigint           not null
#
# Indexes
#
#  index_position_goals_on_department_id  (department_id)
#  index_position_goals_on_employee_id    (employee_id)
#  index_position_goals_on_period_id      (period_id)
#  index_position_goals_on_position_id    (position_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (employee_id => employees.id)
#  fk_rails_...  (period_id => periods.id)
#  fk_rails_...  (position_id => positions.id)
#
class PositionGoal < ApplicationRecord
  belongs_to :position
  belongs_to :period
  belongs_to :department
  belongs_to :employee, optional: true

  # Calculate position score for a specific employee and period
  # Returns the weighted average score if percentages sum to 100% and all scores are present
  def self.position_score_for_employee(employee, period = nil)
    return nil unless employee

    # Use the evaluation's period if none provided
    company = employee.department.company if employee.department
    period ||= company&.periods&.find_by(status: 'abierto')
    return nil unless period

    # Get all position goals for this employee and period
    position_goals = PositionGoal.where(employee: employee, period: period)
    return nil unless position_goals.any?

    # Check if sum of percentages equals 100%
    total_percentage = position_goals.sum(:percentage)
    
    # Check if all scores have values (not null)
    all_scores_present = position_goals.all? { |goal| goal.score.present? }
    
    if total_percentage == 100.0 && all_scores_present
      # Calculate weighted average: (percentage1 * score1 + percentage2 * score2 + ...) / 100
      weighted_sum = position_goals.sum { |goal| (goal.percentage * goal.score) }
      weighted_sum / 100.0
    else
      nil
    end
  end
end
