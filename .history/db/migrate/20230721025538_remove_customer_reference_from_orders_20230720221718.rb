class RemoveCustomerReferenceFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :customer_reference, :string
  end
end
