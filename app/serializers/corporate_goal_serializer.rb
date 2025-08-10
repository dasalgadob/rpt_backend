# == Schema Information
#
# Table name: corporate_goals
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
#  index_corporate_goals_on_dimension_id  (dimension_id)
#  index_corporate_goals_on_period_id     (period_id)
#
# Foreign Keys
#
#  fk_rails_...  (dimension_id => dimensions.id)
#  fk_rails_...  (period_id => periods.id)
#
class CorporateGoalSerializer < ActiveModel::Serializer
  attributes :id, :description, :percentage, :score
  has_one :period
  has_one :dimension
end
