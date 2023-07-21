class AddFieldsToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :first_name, :string
    add_column :customers, :last_name, :string
    add_column :customers, :primary_address, :string
    add_column :customers, :alt_address, :string
    add_column :customers, :primary_city, :string
    add_column :customers, :alt_city, :string
    add_column :customers, :primary_postal_code, :string
    add_column :customers, :alt_postal_code, :string
  end
end
