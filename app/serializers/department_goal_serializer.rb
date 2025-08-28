# == Schema Information
#
# Table name: department_goals
#
#  id            :bigint           not null, primary key
#  description   :string
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
class DepartmentGoalSerializer < ActiveModel::Serializer
  attributes :id, :description, :percentage, :score, :department_id, :department_name, :period, :employee_id, :employee_name, :employee
  belongs_to :period
  belongs_to :department

  def percentage
    object.percentage&.to_f
  end

  def score
    object.score&.to_f
  end
  
  def department_id
    object.department&.id
  end
  
  def department_name
    object.department&.name
  end

  def period
    {
      id: object.period.id,
      name: object.period.name
    }
  end

  def employee_id
    object.employee&.id
  end
  def employee_name
    object.employee&.name
  end
  def employee
    {
      id: object.employee&.id,
      name: object.employee&.name,  
      department: object.employee&.department
    }
  end
end
