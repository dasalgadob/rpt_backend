class AddJobCompetenciesToPositionTypeWeights < ActiveRecord::Migration[7.1]
  def change
    add_column :position_type_weights, :job_competencies, :decimal
  end
end
