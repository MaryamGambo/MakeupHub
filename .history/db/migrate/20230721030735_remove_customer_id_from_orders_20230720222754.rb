class RemoveCustomerIdFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :customer_id, :integer
  end
end
