class PurchasesController < ApplicationController
  def new
    @flight = selected_flight
    @payment_methods = session[:payment_methods]
  end

  def create
    if expedia_checkout?
      success = expedia_service.run!
      flash[:notice] = 'Your checkout with Expedia was successful!'
      redirect_path = root_path
    else
      save_payment_method if save_payment_method?
      success = purchase_service.run!
      flash[:notice] = 'Your purchase was successful!'
      redirect_path =  purchases_path
    end
    if success
      redirect_to redirect_path
    else
      flash[:notice] = 'Failed to complete purchase! Please call support!'
      redirect_to new_purchase_path(destination: params['destination'])
    end
  end

  def index
    transactions = GetSpreedlyTransactions.new(state: 'succeeded').run!
    @purchases = transactions.
      select { |transaction| transaction['transaction_type'] == 'Purchase' }.
      map do |transaction|
        payment_method = transaction['payment_method']
        transaction.
          slice('created_at', 'token', 'amount').
          merge(payment_method.slice('full_name', 'last_four_digits', 'card_type'))
      end
  end

  private

  def expedia_checkout?
    purchase_params['expedia_checkout'] == '1'
  end

  def expedia_service
    SendPaymentMethodToExpedia.new(
      payment_method_token: payment_method_token,
      amount: selected_flight.price.to_f,
      destination: selected_flight
    )
  end

  def flights_data
    session[:flights]
  end

  def payment_method_token
    purchase_params['payment_method_token']
  end

  def purchase_params
    params.
      permit(:destination, :expedia_checkout, :save_payment, :payment_method_token, :utf8,
             :authenticity_token)
  end

  def purchase_service
    CreateSpreedlyPurchase.new(
      payment_method_token: payment_method_token,
      amount: selected_flight.price.to_f,
      retain_on_success: save_payment_method?
    )
  end

  def save_payment_method
    session[:payment_methods] ||= []
    session[:payment_methods] << payment_method_token
  end

  def save_payment_method?
    purchase_params['save_payment'] == '1'
  end

  def selected_flight
    @selected_flight ||= begin
      flight_data = flights_data.
        find { |flight| flight['destination'] == purchase_params[:destination] }
      Flight.new(flight_data.symbolize_keys)
    end
  end
end
