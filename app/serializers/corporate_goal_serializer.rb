# == Schema Information
#
# Table name: corporate_goals
#
#  id                  :bigint           not null, primary key
#  adjustment_factor   :decimal(10, 2)
#  curvature           :decimal(10, 2)
#  curvature2          :decimal(10, 2)
#  description         :string
#  formula_above_value :text
#  formula_below_value :text
#  goal                :text
#  goal_achieved       :decimal(, )
#  goal_ceil           :decimal(, )
#  goal_floor          :decimal(, )
#  goal_value          :decimal(, )
#  inferior_limit      :decimal(10, 2)
#  percentage          :decimal(5, 2)
#  score               :decimal(5, 2)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  dimension_id        :bigint           not null
#  period_id           :bigint           not null
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
  attributes :id, :description, :percentage, :score, :dimension, :period, :goal, :goal_floor, :goal_ceil, :goal_value, :formula_below_value, :formula_above_value, :goal_achieved
  belongs_to :period
  belongs_to :dimension
  
  def percentage
    object.percentage&.to_f
  end

  def score
    s = object.score
    s.nil? ? nil : s.to_f.round(2)
  end
  
  def dimension
    { id: object.dimension.id, name: object.dimension.name }
  end

  def period
    { id: object.period.id, name: object.period.name }
  end

  def goal_floor
    object.goal_floor&.to_f
  end

  def goal_value
    object.goal_value&.to_f
  end

  def goal_ceil
    object.goal_ceil&.to_f
  end

  def goal_achieved
    object.goal_achieved&.to_f
  end
end
