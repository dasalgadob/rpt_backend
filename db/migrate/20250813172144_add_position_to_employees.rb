class AddPositionToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_reference :employees, :position, null: false, foreign_key: true
  end
end
