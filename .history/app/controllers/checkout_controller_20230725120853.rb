class CheckoutController < ApplicationController

  def index
     # Get the cart details and calculate totals
     @cart = session[:cart] || {}
     @subtotal = calculate_subtotal
     @taxes = calculate_taxes(@subtotal)
     @total_price = @subtotal + @taxes

  end

  def guest
    # Check if the form is submitted and handle the form submission
  if request.post?
    address_params = params[:address]

    # Validate the form fields
    if address_params[:address_line1].blank? || address_params[:city].blank? || address_params[:province].blank? || address_params[:postal_code].blank?
      flash.now[:error] = 'Please fill in all the required fields.'
    else
      # Process the valid form submission and save the address to the session
      session[:guest_address] = address_params
      redirect_to checkout_index_path
      return
    end
  end

  # If the form submission is invalid or it's the first visit to the page, render the form
  @address = session[:guest_address] || {} # Use session data if available

  # Fetch the list of provinces for the dropdown select menu
  @provinces_list = provinces_list

  end

  def save_guest_address
     # Check if the form is submitted
    if request.post?
      address = params[:address]
      if valid_guest_address?(address)
        # Save the address data to the session
        session[:guest_address] = address
        redirect_to checkout_index_path
      else
        # Form validation failed, re-render the form with errors
        flash[:error] = 'Please fill out all required fields.'
        render :guest
      end
    end

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
