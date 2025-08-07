class DimensionSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :period
end
