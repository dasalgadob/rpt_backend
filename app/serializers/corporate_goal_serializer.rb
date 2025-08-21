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
  attributes :id, :description, :percentage, :score, :dimension, :period
  belongs_to :period
  belongs_to :dimension
  
  def percentage
    object.percentage&.to_f
  end

  def score
    object.score&.to_f
  end
  
  def dimension
    { id: object.dimension.id, name: object.dimension.name }
  end

  def period
    { id: object.period.id, name: object.period.name }
  end
end
