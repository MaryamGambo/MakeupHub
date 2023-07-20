class HomeController < ApplicationController
  def index
    @available_types = Type.all.sample(3)
    @on_sale_products = Product.where(on_sale_status: true).sample(3)
    @recently_updated_products = Product.order(updated_at: :desc).limit(3)
  end
end
