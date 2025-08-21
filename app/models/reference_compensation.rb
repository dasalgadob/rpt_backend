# == Schema Information
#
# Table name: reference_compensations
#
#  id                  :bigint           not null, primary key
#  compensation        :decimal(, )
#  percentage          :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  profit_reference_id :bigint           not null
#
# Indexes
#
#  index_reference_compensations_on_profit_reference_id  (profit_reference_id)
#
# Foreign Keys
#
#  fk_rails_...  (profit_reference_id => profit_references.id)
#
class ReferenceCompensation < ApplicationRecord
  belongs_to :profit_reference
end
