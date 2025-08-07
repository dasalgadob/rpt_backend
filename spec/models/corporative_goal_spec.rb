# == Schema Information
#
# Table name: corporative_goals
#
#  id           :bigint           not null, primary key
#  description  :string
#  percentage   :decimal(5, 2)
#  score        :decimal(5, 2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  dimension_id :bigint           not null
#  period_id    :bigint           not null
#
# Indexes
#
#  index_corporative_goals_on_dimension_id  (dimension_id)
#  index_corporative_goals_on_period_id     (period_id)
#
# Foreign Keys
#
#  fk_rails_...  (dimension_id => dimensions.id)
#  fk_rails_...  (period_id => periods.id)
#
require 'rails_helper'

RSpec.describe CorporativeGoal, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
