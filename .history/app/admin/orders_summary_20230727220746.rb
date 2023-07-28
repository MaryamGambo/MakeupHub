# app/admin/orders_summary.rb
ActiveAdmin.register_page 'Orders Summary' do
  content title: 'Orders Summary' do
    table_for Customer.joins(orders: :order_items).distinct do
      column 'Customer', :email
      column 'Order ID', sortable: 'orders.id' do |customer|
        customer.orders.map(&:id).join(', ')
      end
      column 'Products Ordered' do |customer|
        customer.orders.joins(:order_items).pluck('order_items.quantity', 'products.name').map { |quantity, name| "#{quantity} x #{name}" }.join(', ')
      end
      column 'Taxes' do |customer|
        taxes = customer.orders.sum(:GST) + customer.orders.sum(:PST) + customer.orders.sum(:HST)
        number_to_currency(taxes)
      end
      column 'Order Grand Total' do |customer|
        grand_total = customer.orders.sum(:total_amount)
        number_to_currency(grand_total)
      end
    end
  end
end
