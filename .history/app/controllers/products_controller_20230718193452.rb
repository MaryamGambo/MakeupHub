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
    elsif params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      @products = @tag.products.page(params[:page]).per(15)
      @association_name = @tag.name
    else
      @products = Product.page(params[:page]).per(15)
    end
  end

  # show page to view individual product pages
  def show
    @product = Product.find(params[:id])
    @category = @product.category
    @brand = @product.brand
    @other_products = @category.products.where.not(id: @product.id)
    @tags = @product.tags

  end



  # navigate through products by filters: on-sale,new,  and recently-updated
  def filter
    @products = Product.all

    if params[:filter].present?
      case params[:filter]
      when 'new'
        @products = @products.where('created_at >= ?', 3.days.ago)
      when 'on_sale'
        @products = @products.where(on_sale_status: true)
      end
    end

    # You may also want to paginate the results
    @products = @products.page(params[:page]).per(15)
  end

  # navigate products by types category
  def filter_by_category
    if params[:type_id].present?
      @products = Product.where(type_id: params[:type_id]).order(created_at: :desc).page(params[:page]).per(15)
    else
      @products = Product.order(created_at: :desc).page(params[:page]).per(15)
    end
  end


  # search products by keywords and categories
  def search
    @products = Product.all

    if params[:type_id].present? && params[:keyword].present?
      @products = @products.where(type_id: params[:type_id])
                           .where('name LIKE ?', "%#{params[:keyword]}%")
    elsif params[:type_id].present?
      @products = @products.where(type_id: params[:type_id])
    elsif params[:keyword].present?
      @products = @products.where('name LIKE ?', "%#{params[:keyword]}%")
    else
      @products = @products
    end
    @total_results = @products.size
    @products = @products.page(params[:page]).per(15)
  end

  def add_to_cart
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    cart = session[:cart] || {}
    cart[product_id] ||= 0
    cart[product_id] += quantity

    session[:cart] = cart
    redirect_to carts_path
    flash[:success] = 'Product added to cart successfully.'
  end

  # private

  # def set_breadcrumb
  #   breadcrumb('Home', root_path)
  #   breadcrumb('Brands', brands_path)
  #   breadcrumb(@brand.name, brand_products_path(@brand))
  #   breadcrumb(@product.name, product_path(@product))
  # end

end
