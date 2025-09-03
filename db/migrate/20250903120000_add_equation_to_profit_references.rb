class AddEquationToProfitReferences < ActiveRecord::Migration[7.1]
  def change
    add_column :profit_references, :equation, :text
  end
end
