class AddPeriodToPositionTypeWeights < ActiveRecord::Migration[7.1]
  def change
    add_reference :position_type_weights, :period, null: false, foreign_key: true
  end
end
