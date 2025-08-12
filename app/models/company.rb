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
  has_many :employees, through: :departments
end
