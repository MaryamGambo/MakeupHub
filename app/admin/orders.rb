ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :order_date, :GST, :HST, :PST, :total_amount, :status, :customer_id, :payment_intent_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:order_date, :GST, :HST, :PST, :total_amount, :status, :customer_id, :payment_intent_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
