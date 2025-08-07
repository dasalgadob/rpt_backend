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
require 'rails_helper'

RSpec.describe DepartmentGoal, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
