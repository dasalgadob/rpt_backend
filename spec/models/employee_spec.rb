# == Schema Information
#
# Table name: employees
#
#  id               :bigint           not null, primary key
#  id_employee      :string
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  department_id    :bigint           not null
#  position_type_id :bigint           not null
#
# Indexes
#
#  index_employees_on_department_id     (department_id)
#  index_employees_on_position_type_id  (position_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (position_type_id => position_types.id)
#
require 'rails_helper'

RSpec.describe Employee, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
