class CorporativeGoalSerializer < ActiveModel::Serializer
  attributes :id, :description, :percentage, :score
  has_one :period
  has_one :dimension
end
