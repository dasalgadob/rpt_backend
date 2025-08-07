class PeriodSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :period_type
  has_one :company
end
