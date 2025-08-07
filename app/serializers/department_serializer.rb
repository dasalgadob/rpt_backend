class DepartmentSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :company
end
