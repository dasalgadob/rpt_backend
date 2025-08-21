class RenameSincePeriodProfitToSincePercentageProfit < ActiveRecord::Migration[7.1]
  def change
        rename_column :profit_references, :since_period_profit, :since_percentage_profit
  end
end
