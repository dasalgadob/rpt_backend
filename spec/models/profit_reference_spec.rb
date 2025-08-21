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
require 'rails_helper'

RSpec.describe ProfitReference, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
