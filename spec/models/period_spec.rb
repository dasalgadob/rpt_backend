# == Schema Information
#
# Table name: periods
#
#  id          :bigint           not null, primary key
#  name        :string
#  period_type :string
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint           not null
#
# Indexes
#
#  index_periods_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe Period, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
