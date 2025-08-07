class PositionGoal < ApplicationRecord
  belongs_to :position
  belongs_to :period
  belongs_to :department
end
