class ProductsController < ApplicationController
  # index page to view all products
  def index
    @products = Product.all
  end
  # show page to view individual product pages
  def show
    @product = Product.find(params[:id])
  end


  # navigate through products by filters: types, on-sale,new,  and recently-updated
  def filter
    @products = Product.all

    if params[:type_id].present?
      @products = @products.where(type_id: params[:type_id])
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


  # search products by keywords and categories
  def search
    @products = Product.all

    if params[:type_id].present? && params[:keyword].present?
      @people = @species.people.where('people.name LIKE ?', "%#{params[:name]}%")
      @products = @products.where(type_id: params[:type_id])
                           .where('name LIKE ?', "%#{params[:keyword]}%")
    elsif params[:keyword].present?
      @products = @products.where('name LIKE ?', "%#{params[:keyword]}%")
    end

  end
end
