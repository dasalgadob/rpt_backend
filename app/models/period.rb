# == Schema Information
#
# Table name: periods
#
#  id                            :bigint           not null, primary key
#  company_profit_percentage     :decimal(5, 2)
#  formula_above_value           :text
#  formula_below_value           :text
#  goal_achieved                 :decimal(, )
#  goal_ceil                     :decimal(, )
#  goal_floor                    :decimal(, )
#  goal_value                    :decimal(, )
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

  def score
    calculate_goal_result&.to_f&.round(2)
  end

  def minimum_score_employee
    read_attribute(:minimum_score_employee)&.to_f
  end

  def goal_floor
    read_attribute(:goal_floor)&.to_f
  end

  def goal_value
    read_attribute(:goal_value)&.to_f
  end

  def goal_ceil
    read_attribute(:goal_ceil)&.to_f
  end

  def goal_achieved
    read_attribute(:goal_achieved)&.to_f
  end

  private

  def only_one_open_period_per_company
    if Period.where(company_id: company_id, status: 'abierto').where.not(id: id).exists?
      errors.add(:base, 'Only one open period is allowed per company')
    end
  end

  def calculate_goal_result
    return 0 if goal_achieved.nil? || goal_floor.nil? || goal_value.nil?
    result = 0 
    x = goal_achieved
    if x >= goal_floor && x <= goal_value
      result = (eval("#{formula_below_value}") * 100)&.to_f
    elsif x > goal_value && x <= goal_ceil
      result = (eval("#{formula_above_value}") * 100)&.to_f
    end
    if result > 110.0
      result = 110.0
    end
    result
  end
end
