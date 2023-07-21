class AddForeignKeysToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_reference :customers, :primary_province, null: true, foreign_key: true
    add_reference :customers, :alt_province, null: true, foreign_key: true
  end
end
