# == Schema Information
#
# Table name: periods
#
#  id                            :bigint           not null, primary key
#  adjustment_factor             :decimal(10, 2)
#  company_profit_percentage     :decimal(5, 2)
#  curvature                     :decimal(10, 2)
#  curvature2                    :decimal(10, 2)
#  formula_above_value           :text
#  formula_below_value           :text
#  goal_achieved                 :decimal(, )
#  goal_ceil                     :decimal(, )
#  goal_floor                    :decimal(, )
#  goal_value                    :decimal(, )
#  inferior_limit                :decimal(10, 2)
#  minimum_score_area_goals      :decimal(5, 2)
#  minimum_score_corporate_goals :decimal(5, 2)
#  minimum_score_employee        :decimal(5, 2)
#  minimum_score_position_goals  :decimal(5, 2)
#  name                          :string
#  period_type                   :string
#  status                        :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  company_id                    :bigint           not null
#
# Indexes
#
#  index_periods_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class PeriodSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :period_type, :minimum_score_employee, :company_profit_percentage, :formula_above_value, :formula_below_value, :goal_floor, :goal_value, :goal_ceil, :goal_achieved
  has_one :company

  def company_profit_percentage
    object.company_profit_percentage&.to_f&.round(2)
  end
end
