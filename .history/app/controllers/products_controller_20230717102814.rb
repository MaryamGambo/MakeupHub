class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def types
    @type =   Type.find(params[:id])
    @products = @type.products
  end
end
