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
#  department_id :bigint           not null
#  period_id     :bigint           not null
#
# Indexes
#
#  index_department_goals_on_department_id  (department_id)
#  index_department_goals_on_period_id      (period_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (period_id => periods.id)
#
class DepartmentGoalSerializer < ActiveModel::Serializer
  attributes :id, :description, :percentage, :score, :department_id, :department_name
  belongs_to :period
  belongs_to :department
  
  def department_id
    object.department.id
  end
  
  def department_name
    object.department.name
  end
end
