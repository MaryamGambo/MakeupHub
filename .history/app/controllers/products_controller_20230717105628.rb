class ProductsController < ApplicationController
  # index page to view all products
  def index
    @products = Product.all
  end
  # show page to view individual product pages
  def show
    @product = Product.find(params[:id])
  end

  # navigate through products by their types
  def type
    @type = Type.find(params[:type_id])
    @products = @type.products
  end

  # navigate through products by filters: types, on-sale, recently-updated
  def filter
    @products = Product.all

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:new].present?
      @products = @products.order(created_at: :desc)
    end

    if params[:recently_updated].present?
      @products = @products.order(updated_at: :desc)
    end

    if params[:on_sale].present?
      @products = @products.where(on_sale_status: true)
    end
  end
end
