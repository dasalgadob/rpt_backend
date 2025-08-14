class CreateEmployeeEvaluations < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_evaluations do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :period, null: false, foreign_key: true
      t.string :evaluation_score

      t.timestamps
    end
  end
end
