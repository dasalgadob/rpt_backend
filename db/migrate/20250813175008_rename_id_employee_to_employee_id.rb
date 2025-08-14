class RenameIdEmployeeToEmployeeId < ActiveRecord::Migration[7.1]
  def change
    rename_column :employees, :id_employee, :employee_id
  end
end
