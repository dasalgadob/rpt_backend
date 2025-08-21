class CreateProfitReferences < ActiveRecord::Migration[7.1]
  def change
    create_table :profit_references do |t|
      t.references :period, null: false, foreign_key: true
      t.decimal :since_period_profit

      t.timestamps
    end
  end
end
