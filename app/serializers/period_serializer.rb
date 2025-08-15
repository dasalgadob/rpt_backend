# == Schema Information
#
# Table name: periods
#
#  id                        :bigint           not null, primary key
#  company_profit_percentage :decimal(5, 2)
#  minimum_score_employee    :decimal(5, 2)
#  name                      :string
#  period_type               :string
#  status                    :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  company_id                :bigint           not null
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
  attributes :id, :name, :status, :period_type, :minimum_score_employee, :company_profit_percentage
  has_one :company
end
