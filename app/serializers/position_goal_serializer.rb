# == Schema Information
#
# Table name: position_goals
#
#  id            :bigint           not null, primary key
#  description   :string
#  goal          :text
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
class PositionGoalSerializer < ActiveModel::Serializer
  attributes :id, :description, :percentage, :score, :position_id, :position_name, :department_id, :department_name, :period_id, :period_name, :employee_id, :employee_name, :employee, :goal
  belongs_to :period
  belongs_to :position
  
  def percentage
    object.percentage&.to_f
  end

  def score
    object.score&.to_f
  end

  def position_id
    object.position.id
  end
  
  def position_name
    object.position.name
  end

  def department_id
    object.department.id
  end

  def department_name
    object.department.name
  end

  def period_id
    object.period.id
  end

  def period_name
    object.period.name
  end

  def employee_id
    object.employee.id if object.employee
  end

  def employee_name
    object.employee.name if object.employee
  end

  def employee
    object.employee if object.employee
  end
end
