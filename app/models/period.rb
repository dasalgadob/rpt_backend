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
class Period < ApplicationRecord
  belongs_to :company

  default_scope { order(name: :desc) }

  enum period_type: { anual: 'anual', trimestral: 'trimestral', semestral: 'semestral' }
  enum status: { abierto: 'abierto', cerrado: 'cerrado' }

  validates :name, presence: true
  validates :period_type, presence: true
  validates :status, presence: true
end
