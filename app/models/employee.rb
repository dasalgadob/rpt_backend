# == Schema Information
#
# Table name: employees
#
#  id               :bigint           not null, primary key
#  is_base_110      :boolean          default(FALSE)
#  name             :string
#  salary           :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  department_id    :bigint           not null
#  employee_id      :string
#  position_id      :bigint           not null
#  position_type_id :bigint
#
# Indexes
#
#  index_employees_on_department_id     (department_id)
#  index_employees_on_position_id       (position_id)
#  index_employees_on_position_type_id  (position_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (position_id => positions.id)
#  fk_rails_...  (position_type_id => position_types.id)
#
class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :position_type, optional: true
  belongs_to :position
  has_many :employee_evaluations, dependent: :destroy
  has_one :company, through: :department
  has_many :department_goals, dependent: :destroy
end
