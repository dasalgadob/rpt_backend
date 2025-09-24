class AddGoalFieldsToPeriods < ActiveRecord::Migration[7.1]
  def change
    add_column :periods, :formula_above_value, :text
    add_column :periods, :formula_below_value, :text
    add_column :periods, :goal_floor, :decimal
    add_column :periods, :goal_value, :decimal
    add_column :periods, :goal_ceil, :decimal
    add_column :periods, :goal_achieved, :decimal
  end
end
