class OrdersController < ApplicationController
  before_action :authenticate_customer!

  def index
    # Fetch orders for the current customer
    @orders = current_customer.orders.order(created_at: :desc)
  end

  def show
    # Fetch the order details for the current customer using their ID
    @order = current_customer.orders.find_by(id: params[:id])

    # Check if the order exists and belongs to the current customer
    if @order.nil?
      flash[:alert] = "Order not found or you don't have access to this order."
      redirect_to orders_path
    end
  end
endre
