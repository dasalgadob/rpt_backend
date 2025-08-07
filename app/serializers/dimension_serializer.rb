# == Schema Information
#
# Table name: dimensions
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  period_id  :bigint           not null
#
# Indexes
#
#  index_dimensions_on_period_id  (period_id)
#
# Foreign Keys
#
#  fk_rails_...  (period_id => periods.id)
#
class DimensionSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :period
end
