class CreateProfitReferenceHasPositionTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :profit_reference_has_position_types do |t|
      t.references :profit_reference, null: false, foreign_key: true
      t.references :position_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
