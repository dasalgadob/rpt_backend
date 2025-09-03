# == Schema Information
#
# Table name: department_goals
#
#  id            :bigint           not null, primary key
#  description   :string
#  goal          :text
#  percentage    :decimal(5, 2)
#  score         :decimal(5, 2)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :bigint
#  employee_id   :bigint
#  period_id     :bigint           not null
#
# Indexes
#
#  index_department_goals_on_department_id  (department_id)
#  index_department_goals_on_employee_id    (employee_id)
#  index_department_goals_on_period_id      (period_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (employee_id => employees.id)
#  fk_rails_...  (period_id => periods.id)
#
class DepartmentGoal < ApplicationRecord
  belongs_to :department, optional: true
  belongs_to :period
  belongs_to :employee, optional: true

  # Scope to filter department goals by department_id through employees
  scope :for_department, ->(department_id) {
    joins(:employee).where(employees: { department_id: department_id })
  }

  scope :for_employee, ->(employee_id) { where(employee_id: employee_id) }

  # Calculate department score for a specific department and period
  # Returns the weighted average score if percentages sum to 100% and all scores are present
  def self.department_score_for_period(employee = nil)
    # Use open period if none provided
    period ||= employee.company.periods.find_by(status: 'abierto')
    return nil unless period && employee

    # Get all department goals for this department and period
    department_goals = DepartmentGoal.where(employee: employee, period: period)
    return nil unless department_goals.any?

    # Check if sum of percentages equals 100%
    total_percentage = department_goals.sum(:percentage)
    
    # Check if all scores have values (not null)
    all_scores_present = department_goals.all? { |goal| goal.score.present? }
    
    if total_percentage == 100.0 && all_scores_present
      # Calculate weighted average: (percentage1 * score1 + percentage2 * score2 + ...) / 100
      weighted_sum = department_goals.sum { |goal| (goal.percentage * goal.score) }
      weighted_sum / 100.0
    else
      nil
    end
  end
end
