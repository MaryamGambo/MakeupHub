class DropCustomersTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :customers
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
