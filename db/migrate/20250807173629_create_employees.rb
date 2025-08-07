class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :id_employee
      t.string :name
      t.references :department, null: false, foreign_key: true
      t.references :position_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
