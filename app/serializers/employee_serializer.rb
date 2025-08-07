class EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :id_employee, :name
  has_one :department
  has_one :position_type
end
