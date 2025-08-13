# == Schema Information
#
# Table name: position_goals
#
#  id            :bigint           not null, primary key
#  description   :string
#  percentage    :decimal(5, 2)
#  score         :decimal(5, 2)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :bigint           not null
#  period_id     :bigint           not null
#  position_id   :bigint           not null
#
# Indexes
#
#  index_position_goals_on_department_id  (department_id)
#  index_position_goals_on_period_id      (period_id)
#  index_position_goals_on_position_id    (position_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (period_id => periods.id)
#  fk_rails_...  (position_id => positions.id)
#
class PositionGoalSerializer < ActiveModel::Serializer
  attributes :id, :description, :percentage, :score, :position_id, :position_name
  belongs_to :period
  belongs_to :position
  
  def position_id
    object.position.id
  end
  
  def position_name
    object.position.name
  end
end
