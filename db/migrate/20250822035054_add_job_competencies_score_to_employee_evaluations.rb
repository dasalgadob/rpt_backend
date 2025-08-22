class AddJobCompetenciesScoreToEmployeeEvaluations < ActiveRecord::Migration[7.1]
  def change
    add_column :employee_evaluations, :job_competencies_score, :decimal
  end
end
