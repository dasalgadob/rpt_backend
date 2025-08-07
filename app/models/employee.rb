class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :position_type
end
