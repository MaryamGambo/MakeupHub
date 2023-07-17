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
    @type =   Type.find(params[:type_id])
    @products = @type.products
  end

  # navigate through products by
  def filter

  end
end
