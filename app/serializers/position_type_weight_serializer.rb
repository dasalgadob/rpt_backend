# == Schema Information
#
# Table name: position_type_weights
#
#  id                    :bigint           not null, primary key
#  corporate_percentage  :decimal(, )
#  department_percentage :decimal(, )
#  position_percentage   :decimal(, )
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  period_id             :bigint           not null
#  position_type_id      :bigint           not null
#
# Indexes
#
#  index_position_type_weights_on_period_id         (period_id)
#  index_position_type_weights_on_position_type_id  (position_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (period_id => periods.id)
#  fk_rails_...  (position_type_id => position_types.id)
#
class PositionTypeWeightSerializer < ActiveModel::Serializer
  attributes :id, :corporate_percentage, :department_percentage, :position_percentage
  has_one :position_type
end
