class RenameCorporativeGoalsToCorporateGoals < ActiveRecord::Migration[7.1]
  def change
    rename_table :corporative_goals, :corporate_goals
  end
end
