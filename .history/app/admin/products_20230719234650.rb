ActiveAdmin.register Product do
  config.filters = false

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :brand_id, :type_id, :category_id, :price, :description, :on_sale_status, :image

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute


    f.input :image, as: :file, hint: f.object.image.attached? ? image_tag(f.object.image.variant(resize: '200x200')) : content_tag(:span, 'No image yet')

    f.inputs do
      f.input :image, as: :file
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end


  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :brand_id, :type_id, :category_id, :price, :description, :on_sale_status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
