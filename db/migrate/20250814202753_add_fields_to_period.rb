class AddFieldsToPeriod < ActiveRecord::Migration[7.1]
  def change
    add_column :periods, :minimum_score_employee, :decimal, precision: 5, scale: 2
    add_column :periods, :company_profit_percentage, :decimal, precision: 5, scale: 2
  end
end
