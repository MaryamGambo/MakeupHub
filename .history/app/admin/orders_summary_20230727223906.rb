ActiveAdmin.register_page 'Orders Summary' do
  content title: 'Orders Summary' do
    Customer.joins(orders: :order_items).distinct.each do |customer|
      panel "Orders for Customer #{customer.email}" do
        table_for customer.orders do
          column 'Order ID', sortable: 'orders.id' do |order|
            order.id
          end
          column 'Products Ordered' do |order|
            order.order_items.joins(:product).pluck('order_items.quantity', 'products.name').map { |quantity, name| "#{quantity} x #{name}" }.join(', ')
          end
          column 'Taxes' do |order|
            taxes = order.GST + order.PST + order.HST
            number_to_currency(taxes)
          end
          column 'Order Total' do |order|
            number_to_currency(order.total_amount)
          end
          column 'Order Status' do |order|
            order.status
          end
        end
      end
    end
  end
end
