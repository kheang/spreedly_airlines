class CreateSpreedlyPurchase
  attr_reader :amount, :payment_method_token, :retain_on_success, :purchase_response

  BASE_URI = 'https://core.spreedly.com/v1'
  CURRENCY_CODE = 'USD'

  def initialize(payment_method_token:, amount:, retain_on_success:)
    @payment_method_token = payment_method_token
    @amount = amount
    @retain_on_success = retain_on_success
  end

  def run!
    @purchase_response = purchase_request
    purchase_response.parsed_response.dig('transaction','succeeded')
  end

  private

  def amount_in_cents
    (amount * 100).to_i
  end

  def purchase_request
    HTTParty.post(
      "#{BASE_URI}/gateways/#{ENV['SPREEDLY_GATEWAY_TOKEN']}/purchase.json",
      basic_auth: {
        username: Rails.application.credentials.spreedly[:env_key],
        password: ENV['SPREEDLY_SECRET']
      },
      headers: {
        'Content-Type' => 'application/json'
      },
      body: {
        transaction: {
          payment_method_token: payment_method_token,
          amount: amount_in_cents,
          currency_code: CURRENCY_CODE,
          retain_on_success: retain_on_success
        }
      }.to_json
    )
  end
end
