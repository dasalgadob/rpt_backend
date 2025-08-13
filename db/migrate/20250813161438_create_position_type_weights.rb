class CreatePositionTypeWeights < ActiveRecord::Migration[7.1]
  def change
    create_table :position_type_weights do |t|
      t.references :position_type, null: false, foreign_key: true
      t.decimal :corporate_percentage
      t.decimal :department_percentage
      t.decimal :position_percentage

      t.timestamps
    end
  end
end
