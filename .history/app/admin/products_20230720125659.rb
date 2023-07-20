ActiveAdmin.register Product do
  config.filters = false

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :brand_id, :type_id, :category_id, :price, :description, :on_sale_status, :image, tag_ids:[]


   # edit and new form page
  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attributes
    f.inputs do
      if f.object.image.attached?
        f.input :image, as: :file, hint: image_tag(f.object.image.variant(resize_to_fill: [100, 100]))
      else
        f.input :image, as: :file
      end
    end

    f.input :tags, as: :check_boxes, collection: Tag.all.map { |tag| [tag.name, tag.id] }
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end


   # index page
  index do
    selectable_column
    id_column
    column :image do |product|
      if product.image.attached?
        image_tag product.image.variant(resize_to_limit: [100, 100])
      else
        "No image attached"
      end
    end
    column :name
    column :brand
    column :type
    column :category
    column :price
    column :on_sale_status
    column :tags do |product|
      tags = product.tags.pluck(:name).join(', ')
      tags.present? ? tags : 'N/A'
    end
    # column :tags do |product|
      # product.tags.each do |tag|
        # span tag.name
      # end
    # end
    column :created_at
    column :updated_at
    actions
  end

  # show page
  show do
    attributes_table do
      row :id
      row :name
      row :brand
      row :type
      row :category
      row :price
      row :description
      row :on_sale_status
      row :image do |product|
        if product.image.attached?
          image_tag product.image.variant(resize_to_limit: [200, 200])
        else
          "No image attached"
        end
      end
      row :tags do |product|
        product.tags.each do |tag|
          span tag.name
        end
      end
    end
    active_admin_comments
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
