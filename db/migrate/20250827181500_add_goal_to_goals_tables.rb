class AddGoalToGoalsTables < ActiveRecord::Migration[6.0]
  def change
    add_column :corporate_goals, :goal, :text
    add_column :department_goals, :goal, :text
    add_column :position_goals, :goal, :text
  end
end
