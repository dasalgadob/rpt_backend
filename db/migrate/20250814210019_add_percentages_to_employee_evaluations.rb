class AddPercentagesToEmployeeEvaluations < ActiveRecord::Migration[7.1]
  def change
    add_column :employee_evaluations, :corporate_percentage, :decimal
    add_column :employee_evaluations, :department_percentage, :decimal
    add_column :employee_evaluations, :position_percentage, :decimal
  end
end
