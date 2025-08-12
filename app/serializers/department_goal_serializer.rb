class DepartmentGoalSerializer < ActiveModel::Serializer
  attributes :id, :description, :percentage, :score, :department_id, :department_name
  belongs_to :period
  belongs_to :department
  
  def department_id
    object.department.id
  end
  
  def department_name
    object.department.name
  end
end
