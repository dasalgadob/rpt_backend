class AddMinimumScoresToPeriods < ActiveRecord::Migration[6.0]
  def change
    add_column :periods, :minimum_score_corporate_goals, :decimal, precision: 5, scale: 2
    add_column :periods, :minimum_score_area_goals, :decimal, precision: 5, scale: 2
    add_column :periods, :minimum_score_position_goals, :decimal, precision: 5, scale: 2
  end
end
