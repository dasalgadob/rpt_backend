# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  name       :string
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Company < ApplicationRecord
  has_many :departments, dependent: :destroy
  has_many :periods, dependent: :destroy
  has_many :positions, dependent: :destroy
  has_many :position_types, dependent: :destroy
  has_many :employees, through: :departments
  has_many :profit_references, through: :periods
  has_many :profit_reference_has_position_types, through: :profit_references
  has_many :reference_compensations, through: :profit_references

  has_many :corporate_goals, through: :periods
  has_many :department_goals, through: :periods
  has_many :position_goals, through: :periods

  has_many :dimensions, through: :periods
  has_many :employee_evaluations, through: :periods
  has_many :position_type_weights, through: :periods

  validates :name, presence: true

end
