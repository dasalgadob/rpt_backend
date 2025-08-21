# == Schema Information
#
# Table name: profit_reference_has_position_types
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  position_type_id    :bigint           not null
#  profit_reference_id :bigint           not null
#
# Indexes
#
#  idx_on_profit_reference_id_ad1ee1ae05                          (profit_reference_id)
#  index_profit_reference_has_position_types_on_position_type_id  (position_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (position_type_id => position_types.id)
#  fk_rails_...  (profit_reference_id => profit_references.id)
#
class ProfitReferenceHasPositionTypeSerializer < ActiveModel::Serializer
  attributes :id
  has_one :profit_reference
  has_one :position_type
end
