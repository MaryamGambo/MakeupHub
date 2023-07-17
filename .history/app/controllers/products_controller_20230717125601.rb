class ProductsController < ApplicationController
  # index page to view all products
  def index
    if params[:type_id]
      @type = Type.find(params[:type_id])
      @products = @type.products.page(params[:page]).per(15)
      @association_name = @type.name
    elsif params[:category_id]
      @category = Category.find(params[:category_id])
      @products = @category.products.page(params[:page]).per(15)
      @association_name = @category.name
    elsif params[:brand_id]
      @brand = Brand.find(params[:brand_id])
      @products = @brand.products.page(params[:page]).per(15)
      @association_name = @brand.name
    else
      @products = Product.page(params[:page]).per(15)
    end
  end
  # show page to view individual product pages
  def show
    @product = Product.find(params[:id])
  end


  # navigate through products by filters: types, on-sale,new,  and recently-updated
  def filter
    @products = Product.page(params[:page]).per(15)

    if params[:type_id].present?
      @products = @products.where(type_id: params[:type_id]).page(params[:page]).per(15)
    end

    if params[:new].present?
      @products = @products.order(created_at: :desc).page(params[:page]).per(15)
    end

    if params[:recently_updated].present?
      @products = @products.order(updated_at: :desc).page(params[:page]).per(15)
    end

    if params[:on_sale].present?
      @products = @products.where(on_sale_status: true).page(params[:page]).per(15)
    end
  end


  # search products by keywords and categories
  def search
    @products = Product.all

    if params[:type_id].present? && params[:keyword].present?
      @products = @products.where(type_id: params[:type_id])
                           .where('name LIKE ?', "%#{params[:keyword]}%").page(params[:page]).per(15)
    elsif params[:keyword].present?
      @products = @products.where('name LIKE ?', "%#{params[:keyword]}%").page(params[:page]).per(15)
    end

  end
end
