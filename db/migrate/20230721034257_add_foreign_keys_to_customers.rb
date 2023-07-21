class AddForeignKeysToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_reference :customers, :primary_province, foreign_key: { to_table: :provinces }, null: true
    add_reference :customers, :alt_province, foreign_key: { to_table: :provinces }, null: true
  end
end

