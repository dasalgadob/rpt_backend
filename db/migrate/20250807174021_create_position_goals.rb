class CreatePositionGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :position_goals do |t|
      t.references :position, null: false, foreign_key: true
      t.references :period, null: false, foreign_key: true
      t.string :description
      t.decimal :percentage, precision: 5, scale: 2
      t.decimal :score, precision: 5, scale: 2
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
