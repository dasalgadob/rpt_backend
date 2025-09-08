# == Schema Information
#
# Table name: periods
#
#  id                            :bigint           not null, primary key
#  company_profit_percentage     :decimal(5, 2)
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
class Period < ApplicationRecord
  belongs_to :company
  has_many :profit_references, dependent: :destroy

  has_many :corporate_goals
  has_many :department_goals
  has_many :position_goals

  has_many :dimensions
  has_many :employee_evaluations
  has_many :position_type_weights

  default_scope { order(name: :desc) }

  enum period_type: { anual: 'anual', trimestral: 'trimestral', semestral: 'semestral' }
  enum status: { abierto: 'abierto', cerrado: 'cerrado' }

  validates :name, presence: true
  validates :period_type, presence: true
  validates :status, presence: true
  validate :only_one_open_period_per_company, if: -> { status == 'abierto' }
  validates :company_profit_percentage, :minimum_score_area_goals, :minimum_score_corporate_goals,
            :minimum_score_employee, :minimum_score_position_goals,
            numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  private

  def only_one_open_period_per_company
    if Period.where(company_id: company_id, status: 'abierto').where.not(id: id).exists?
      errors.add(:base, 'Only one open period is allowed per company')
    end
  end
end
