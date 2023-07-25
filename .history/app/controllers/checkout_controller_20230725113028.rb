class CheckoutController < ApplicationController

  def index
     # Get the cart details and calculate totals
     @cart = session[:cart] || {}
     @subtotal = calculate_subtotal
     @taxes = calculate_taxes(@subtotal)
     @total_price = @subtotal + @taxes

  end

  def guest

  end

  def save_guest_address
    # Get the address details from the form and save them to the session
    address_params = params.require(:address).permit(:address_line1, :address_line2, :city, :province, :postal_code)
    session[:guest_address] = address_params

    # Redirect to the checkout index page after saving the address
    redirect_to checkout_index_path
  end

  def calculate_subtotal
    subtotal = 0
    @cart.each do |product_id, quantity|
      product = Product.find(product_id)
      product_price = product.price * quantity
      subtotal += product_price
    end
    subtotal
  end

  def calculate_taxes(subtotal)
    province = nil

    if current_customer.primary_address || current_customer.alt_address
      # Customer is logged in and has a primary or alternate address saved
      # Use the province from the address to calculate taxes
      province = current_customer.primary_address&.province || current_customer.alt_address&.province
    elsif session[:guest_address]
      # Customer is not logged in, but has an address saved in the session (guest checkout)
      # Use the address province from the session to calculate taxes
      province = session[:guest_address][:province]
    end

    return 0 unless province

    gst_rate = province.GST.to_f
    pst_rate = province.PST.to_f
    hst_rate = province.HST.to_f

    gst_amount = subtotal * gst_rate
    pst_amount = subtotal * pst_rate
    hst_amount = subtotal * hst_rate

    gst_amount + pst_amount + hst_amount
  end

  def create

  end

  def success

  end

  def cancel

  end

end
