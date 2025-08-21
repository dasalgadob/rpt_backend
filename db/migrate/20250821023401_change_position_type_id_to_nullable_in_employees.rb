class ChangePositionTypeIdToNullableInEmployees < ActiveRecord::Migration[7.1]
  def change
    change_column_null :employees, :position_type_id, true
  end
end
