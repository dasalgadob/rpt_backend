class RenameJobCompetenciesToJobCompetenciesPercentageInPositionTypeWeights < ActiveRecord::Migration[7.1]
  def change
    rename_column :position_type_weights, :job_competencies, :job_competencies_percentage
  end
end
