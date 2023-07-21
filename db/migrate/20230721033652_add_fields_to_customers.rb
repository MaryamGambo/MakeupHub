class AddFieldsToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :first_name, :string, null: true
    add_column :customers, :last_name, :string, null: true
    add_column :customers, :primary_address, :string, null: true
    add_column :customers, :alt_address, :string, null: true
    add_column :customers, :primary_city, :string, null: true
    add_column :customers, :alt_city, :string, null: true
    add_column :customers, :primary_postal_code, :string, null: true
    add_column :customers, :alt_postal_code, :string, null: true
  end
end
