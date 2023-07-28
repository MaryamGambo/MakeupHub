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
      product_price = (product.price * quantity * 100)
      {
        price_data: {
          currency: 'cad',
          product_data: {
            name: product.name,
          },
          unit_amount: (product.price * 100).to_i, # Stripe requires the amount in cents
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

    # Set customer details and address for metadata
    customer_province = {}
    if customer_signed_in?
      # Customer is logged in, use the primary address if available, otherwise use alternate address
      customer = current_customer
      if customer.primary_address.present?
        customer_address = {
          address: customer.primary_address,
          city: customer.primary_city,
          postal_code: customer.primary_postal_code,
          province: customer.primary_province.id
        }
      else
        customer_address = {
          address: customer.alt_address,
          city: customer.alt_city,
          postal_code: customer.alt_postal_code,
          province: customer.alt_province.id
        }
      end
    elsif session[:guest_address].present?
      # Customer is not logged in, but has an address saved in the session (guest checkout)
      guest_address = session[:guest_address]
      customer_address = {
        address: guest_address['address_line1'],
        city: guest_address['city'],
        postal_code: guest_address['postal_code'],
        province:guest_address['province']
      }
    end

    # Create a Stripe Checkout Session with the Stripe gem
    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      success_url: "https://fb14-198-163-150-11.ngrok-free.app/checkout/success?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "https://fb14-198-163-150-11.ngrok-free.app/checkout/cancel",
      metadata: {
        customer_address: customer_address.to_json,
        cart_info: @cart.to_json
      }
     })



     puts session.inspect
      # debug
    # Redirect to the Stripe-hosted checkout page
    redirect_to session.url, allow_other_host: true, status: 303


  end

  def success
     # Retrieve the session_id from the query parameters
     session_id = params[:session_id]

     # Get the Stripe Checkout Session from Stripe using the session_id
     stripe_session = Stripe::Checkout::Session.retrieve(session_id)

     # Get the Stripe payment intent ID from the Stripe Checkout Session
     payment_intent_id = stripe_session.payment_intent

     @customer_email = stripe_session.customer_details.email
     @customer_name = stripe_session.customer_details.name
      # Get customer province from metadata
     metadata = stripe_session.metadata
     customer_address = JSON.parse(metadata['customer_address'])
     @customer_address = {
      address: customer_address['address'],
      city: customer_address['city'],
      postal_code: customer_address['postal_code'],
      province: customer_address['province']
    }

    puts "Customer Address: #{@customer_address}"



    # Fetch the HST, GST, and PST values from the provinces table using the address province
    province = Province.find_by(id: @customer_address[:province])
    gst_rate = province.GST.to_f
    pst_rate = province.PST.to_f
    hst_rate = province.HST.to_f

    puts " gst: #{gst_rate}"
    puts " pst: #{pst_rate}"
    puts " hst: #{hst_rate}"

    # Get cart info from metadata and parse it back into a Ruby hash
  @cart_info = JSON.parse(metadata['cart_info'])

  # Calculate the subtotal using data from the metadata saved cart
  @subtotal = 0
  @cart_info.each do |product_id, quantity|
    product = Product.find(product_id)
    product_price = product.price * quantity
    @subtotal += product_price
  end

  # Calculate the gst_amount, hst_amount, pst_amount, and total_amount using data from the metadata saved cart
  @gst_amount = @subtotal * gst_rate
  @pst_amount = @subtotal * pst_rate
  @hst_amount = @subtotal * hst_rate
  @total_amount = @subtotal + @gst_amount + @pst_amount + @hst_amount

  puts "Subtotal: #{@subtotal}"
  puts "GST Amount: #{@gst_amount}"
  puts "PST Amount: #{@pst_amount}"
  puts "HST Amount: #{@hst_amount}"
  puts "Total Amount: #{@total_amount}"

  # Create the order in your database and associate it with the customer
   @order = Order.create!(
     order_date: Date.current,
     GST: @gst_amount,
     HST: @hst_amount,
     PST: @pst_amount,
     total_amount: @total_amount,
     status: 'paid',
     customer_id: customer_signed_in? ? current_customer.id : nil,
     payment_intent_id: payment_intent_id
   )

  # Save order items to the order_items table using the metadata cart info
  @cart_info.each do |product_id, quantity|
    product = Product.find(product_id)
    product_price = product.price * quantity
    OrderItem.create!(
      product_id: product.id,
      order_id: @order.id,
      quantity: quantity,
      price: product_price,
    )
  end

  # Clear the cart after successful order creation
  session[:cart] = nil


  end

  def cancel

  end



end
