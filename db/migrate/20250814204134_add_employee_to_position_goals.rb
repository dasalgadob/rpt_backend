class AddEmployeeToPositionGoals < ActiveRecord::Migration[7.1]
  def change
    add_reference :position_goals, :employee, foreign_key: true
  end
end
