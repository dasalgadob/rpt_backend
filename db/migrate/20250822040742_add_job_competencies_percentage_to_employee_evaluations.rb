class AddJobCompetenciesPercentageToEmployeeEvaluations < ActiveRecord::Migration[7.1]
  def change
    add_column :employee_evaluations, :job_competencies_percentage, :decimal
  end
end
