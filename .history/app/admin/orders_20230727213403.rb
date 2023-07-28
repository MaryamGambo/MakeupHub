ActiveAdmin.register Order do
  config.filters = false

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :order_date, :GST, :HST, :PST, :total_amount, :status, :customer_id, :payment_intent_id

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :order_date
      f.input :GST
      f.input :HST
      f.input :PST
      f.input :total_amount
      f.input :status, as: :select, collection: ['new', 'paid', 'shipped']
      f.input :customer_id
      f.input :payment_intent_id
    end
    f.actions
  end








end
