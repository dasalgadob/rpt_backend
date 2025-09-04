# == Schema Information
#
# Table name: profit_references
#
#  id                      :bigint           not null, primary key
#  equation                :text
#  since_percentage_profit :decimal(, )
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  period_id               :bigint           not null
#
# Indexes
#
#  index_profit_references_on_period_id  (period_id)
#
# Foreign Keys
#
#  fk_rails_...  (period_id => periods.id)
#
class ProfitReferenceSerializer < ActiveModel::Serializer
  attributes :id, :since_percentage_profit, :period_name, :period_id, :profit_reference_has_position_types_data, :equation
  has_one :period
  
  def period_name
    object.period.name if object.period
  end

  def period_id
    object.period.id if object.period
  end

  def profit_reference_has_position_types_data
    object.profit_reference_has_position_types.map do |prh_pt|
      {
        id: prh_pt.id,
        position_type_id: prh_pt.position_type_id,
        position_type_name: prh_pt.position_type&.name
      }
    end
  end

  def since_percentage_profit
    object.since_percentage_profit&.to_f
  end
end
