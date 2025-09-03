class AddGoalFieldsToCorporateGoals < ActiveRecord::Migration[7.1]
  def change
    add_column :corporate_goals, :goal_floor, :decimal
    add_column :corporate_goals, :goal_value, :decimal
    add_column :corporate_goals, :goal_ceil, :decimal
    add_column :corporate_goals, :goal_achieved, :decimal
    add_column :corporate_goals, :formula_below_value, :text
    add_column :corporate_goals, :formula_above_value, :text
  end
end
