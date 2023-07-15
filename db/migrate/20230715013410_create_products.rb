class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.references :brand, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.decimal :price
      t.text :description
      t.boolean :on_sale_status

      t.timestamps
    end
  end
end
