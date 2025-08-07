class CreatePeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :periods do |t|
      t.string :name
      t.string :status
      t.string :period_type
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
