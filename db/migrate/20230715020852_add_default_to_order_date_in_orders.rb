class AddDefaultToOrderDateInOrders < ActiveRecord::Migration[7.0]
  def change
    change_column_default :orders, :order_date, from: nil, to: -> { 'CURRENT_DATE' }
  end
end
