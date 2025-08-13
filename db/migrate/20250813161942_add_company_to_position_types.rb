class AddCompanyToPositionTypes < ActiveRecord::Migration[7.1]
  def change
    add_reference :position_types, :company, null: false, foreign_key: true
  end
end
