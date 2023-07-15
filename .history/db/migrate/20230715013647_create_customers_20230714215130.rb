class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :primary_address
      t.string :primary_city
      t.references :primary_province, null: false, foreign_key: true
      t.string :primary_postal_code
      t.string :alt_address
      t.string :alt_city
      t.references :alt_province, null: false, foreign_key: true
      t.string :alt_postal_code
      t.string :password

      t.timestamps
    end
  end
end
