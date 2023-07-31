class CartsController < ApplicationController
  def show
    @cart = session[:cart] || {}
  end

  def update
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    cart = session[:cart] || {}
    cart[product_id] = quantity

    session[:cart] = cart

    redirect_to cart_path, flash: { notice: 'Product updated successfully.' }
  end

  def remove
    product_id = params[:product_id]

    cart = session[:cart] || {}
    cart.delete(product_id)

    session[:cart] = cart

    redirect_to cart_path, flash: {notice: 'Product removed from cart successfully.' }
  end
end