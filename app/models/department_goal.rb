class DepartmentGoal < ApplicationRecord
  belongs_to :department
  belongs_to :period
end
