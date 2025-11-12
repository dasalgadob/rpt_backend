# == Schema Information
#
# Table name: employees
#
#  id               :bigint           not null, primary key
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
class EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :employee_id, :name, :salary, :department_id, :department_name, :position_id, :position_name, :position_type_id, :position_type_name, :employee_name, :employee_id, :position_type_weight

  belongs_to :department
  belongs_to :position
  belongs_to :position_type

  def department_id
    object.department_id
  end

  def department_name
    object.department&.name
  end

  def position_type_id
    object.position_type&.id
  end

  def position_type_name
    object.position_type&.name
  end

  def position_id
    object.position&.id
  end

  def position_name
    object.position&.name
  end

  def employee_id
    object.employee_id
  end

  def employee_name
    object.name
  end

  def position_type_weight
    object.position_type&.position_type_weights
  end

  def salary
    object.salary&.to_f&.round(2)
  end
end
