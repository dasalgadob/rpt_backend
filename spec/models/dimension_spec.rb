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
require 'rails_helper'

RSpec.describe Dimension, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
