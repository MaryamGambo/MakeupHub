ActiveAdmin.register Province do
  config.filters = false

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :tax_type, :GST, :PST, :HST
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :tax_type, :GST, :PST, :HST]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
