class CreateReferenceCompensations < ActiveRecord::Migration[7.1]
  def change
    create_table :reference_compensations do |t|
      t.references :profit_reference, null: false, foreign_key: true
      t.decimal :percentage
      t.decimal :compensation

      t.timestamps
    end
  end
end
