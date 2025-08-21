# == Schema Information
#
# Table name: profit_references
#
#  id                      :bigint           not null, primary key
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
class ProfitReference < ApplicationRecord

  default_scope { order(since_percentage_profit: :asc) }
  belongs_to :period
  has_many :profit_reference_has_position_types, dependent: :destroy
  has_many :position_types, through: :profit_reference_has_position_types
  has_many :reference_compensations, dependent: :destroy
  
  accepts_nested_attributes_for :profit_reference_has_position_types, allow_destroy: true
end
