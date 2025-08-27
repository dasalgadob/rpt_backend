class MakeDepartmentIdOptionalAndAddEmployeeIdToDepartmentGoals < ActiveRecord::Migration[6.0]
  def change
    # Make department_id optional
    change_column_null :department_goals, :department_id, true

    # Add employee_id reference (optional)
    add_reference :department_goals, :employee, foreign_key: true, null: true
  end
end
