class CreateCorporativeGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :corporative_goals do |t|
      t.references :period, null: false, foreign_key: true
      t.string :description
      t.decimal :percentage, precision: 5, scale: 2
      t.decimal :score, precision: 5, scale: 2
      t.references :dimension, null: false, foreign_key: true

      t.timestamps
    end
  end
end
