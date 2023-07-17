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

  # navigate through products by
  def filter
    case params[:filter]
    when 'on_sale'
      @products = Product.where(on_sale_status: true)
    when 'new'
      @products = Product.order(created_at: :desc)
    when 'recently_updated'
      @products = Product.order(updated_at: :desc)
    else
      @products = Product.all
    end

  end
end
