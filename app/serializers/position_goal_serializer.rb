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
