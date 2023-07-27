class ChangeCustomerIdToAcceptNullInOrders < ActiveRecord::Migration[7.0]
    def up
      # Change the foreign key constraint to allow null values
      change_column_null :orders, :customer_id, true
    end
end
