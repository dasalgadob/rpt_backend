class CreateDimensions < ActiveRecord::Migration[7.1]
  def change
    create_table :dimensions do |t|
      t.string :name
      t.references :period, null: false, foreign_key: true

      t.timestamps
    end
  end
end
