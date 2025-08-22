# == Schema Information
#
# Table name: employee_evaluations
#
#  id                     :bigint           not null, primary key
#  corporate_percentage   :decimal(, )
#  department_percentage  :decimal(, )
#  evaluation_score       :string
#  job_competencies_score :decimal(, )
#  position_percentage    :decimal(, )
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  employee_id            :bigint           not null
#  period_id              :bigint           not null
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
