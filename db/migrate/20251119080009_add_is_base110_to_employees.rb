class AddIsBase110ToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :is_base_110, :boolean, default: false
  end
end
