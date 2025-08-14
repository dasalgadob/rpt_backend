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
require 'rails_helper'

RSpec.describe EmployeeEvaluation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
