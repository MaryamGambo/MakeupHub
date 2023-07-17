class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @person = Person.find(params[:id])
  end
end
