class RemoveCustomerReferenceFromOrders < ActiveRecord::Migration[7.0]
  def change
    change_column_default :orders, :order_date, from: nil, to: -> { 'CURRENT_DATE' }
    remove_column :orders, :customer_id, :integer
  end
end
