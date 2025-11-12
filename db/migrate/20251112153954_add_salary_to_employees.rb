class AddSalaryToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :salary, :decimal
  end
end
