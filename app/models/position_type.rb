# == Schema Information
#
# Table name: position_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint           not null
#
# Indexes
#
#  index_position_types_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class PositionType < ApplicationRecord
  belongs_to :company
  has_many :profit_reference_has_position_types, dependent: :destroy
  has_many :profit_references, through: :profit_reference_has_position_types
  has_many :position_type_weights, dependent: :destroy
end
