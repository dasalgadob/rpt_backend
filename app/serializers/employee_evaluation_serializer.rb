# == Schema Information
#
# Table name: employee_evaluations
#
#  id               :bigint           not null, primary key
#  evaluation_score :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  employee_id      :bigint           not null
#  period_id        :bigint           not null
#
# Indexes
#
#  index_employee_evaluations_on_employee_id  (employee_id)
#  index_employee_evaluations_on_period_id    (period_id)
#
# Foreign Keys
#
#  fk_rails_...  (employee_id => employees.id)
#  fk_rails_...  (period_id => periods.id)
#
class EmployeeEvaluationSerializer < ActiveModel::Serializer
  attributes :id, :evaluation_score
  has_one :employee
  has_one :period
end
