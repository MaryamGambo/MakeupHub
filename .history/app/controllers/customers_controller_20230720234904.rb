class CustomersController < ApplicationController
  before_action :authenticate_customer! # This ensures that the user is logged in before accessing the actions
  before_action :find_customer, only: [:show, :edit, :update]

  def show
    # The customer details are already loaded in the before_action.
  end

  def edit
    # The customer details are already loaded in the before_action.
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: 'Customer details updated successfully.'
    else
      render :edit
    end
  end

  private

  def find_customer
    @customer = current_customer
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name,:email, :primary_address, :alt_address,
                                     :primary_city, :alt_city, :primary_postal_code, :alt_postal_code,
                                     :primary_province_id, :alt_province_id)
  end
end
