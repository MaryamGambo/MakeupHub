class CheckoutController < ApplicationController
  #require 'stripe'

  def index
     # Get the cart details and calculate totals
     @cart = session[:cart] || {}
     @subtotal = calculate_subtotal
     @taxes = calculate_taxes(@subtotal)
     @total_price = @subtotal + @taxes

  end

  def guest
  # Fetch the list of provinces for the dropdown select menu
  @address ||= session[:guest_address] || {}
  @provinces_list = Province.all.map { |province| [province.name, province.id] }

  end

  def save_guest_address
    # Check if the form is submitted and handle the form submission
    if request.post?
      address_params = params[:address]

      # Validate the form fields
      if address_params[:address_line1].blank? || address_params[:city].blank? || address_params[:province].blank? || address_params[:postal_code].blank?
        flash[:error] = 'Please fill in all the required fields.'
      else
        # Process the valid form submission and save the address to the session
        session[:guest_address] = address_params

        redirect_to checkout_index_path
        return
      end
    end

      # If the form submission is invalid or it's the first visit to the page, render the form
      @address ||= session[:guest_address] || {}
      @provinces_list = Province.all.map { |province| [province.name, province.id] }

      redirect_to checkout_guest_path, flash: { error: 'Please fill in all the required fields.' }
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
    province_id = nil

    if customer_signed_in? && (current_customer.primary_address || current_customer.alt_address)
      # Customer is logged in and has a primary or alternate address saved
      # Use the province from the address to calculate taxes
      province_id = current_customer.primary_province || current_customer.alt_province
    elsif session[:guest_address].present?
      # Customer is not logged in, but has an address saved in the session (guest checkout)
      # Use the address province from the session to calculate taxes
      province_id = (session[:guest_address]['province'])
    end

    province = Province.find_by(id: province_id)

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

    @cart = session[:cart] || {}
    subtotal = calculate_subtotal
    taxes = calculate_taxes(subtotal)
    total_price = subtotal + taxes
    # Calculate the total amount for payment (subtotal + taxes) in cents
    total_amount_cents = (@total_price).to_i * 100

    # Create line items for Stripe checkout
    line_items = @cart.map do |product_id, quantity|
      product = Product.find(product_id)
      product_price = product.price * quantity
      {
        price_data: {
          currency: 'cad',
          product_data: {
            name: product.name,
          },
          unit_amount: (product_price * 100).to_i, # Stripe requires the amount in cents
        },
        quantity: quantity,
      }
    end

    # Add a line item for taxes
    taxes_item = {
      price_data: {
        currency: 'cad', # Change this to your desired currency
        product_data: {
          name: 'Calculated Taxes',
        },
        unit_amount: (taxes * 100).to_i, # Stripe requires the amount in cents
      },
      quantity: 1
    }

    # Add the taxes line item to the existing line items
    line_items << taxes_item

    # Create a Stripe Checkout Session with the Stripe gem
    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      success_url: "https://9bbf-198-163-150-11.ngrok-free.app/checkout/success",
      cancel_url: "https://9bbf-198-163-150-11.ngrok-free.app/checkout/cancel",
     })



     puts session.inspect
      # debug
    # Redirect to the Stripe-hosted checkout page
    redirect_to session.url, allow_other_host: true


  end

  def success

  end

  def cancel

  end



end
