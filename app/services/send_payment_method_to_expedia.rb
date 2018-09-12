class SendPaymentMethodToExpedia
  attr_reader :amount, :payment_method_token, :receiver_response, :destination

  BASE_URI = 'https://core.spreedly.com/v1'
  CURRENCY_CODE = 'USD'
  RECEIVER_URL = 'https://spreedly-echo.herokuapp.com'

  def initialize(payment_method_token:, amount:, destination:)
    @payment_method_token = payment_method_token
    @amount = amount
    @destination = destination
  end

  def run!
    @receiver_response = purchase_request
    receiver_response.parsed_response.dig('transaction', 'succeeded')
  end

  private

  def amount_in_cents
    (amount * 100).to_i
  end

  def purchase_request
    HTTParty.post(
      "#{BASE_URI}/receivers/#{ENV['SPREEDLY_RECEIVER_TOKEN']}/deliver.json",
      basic_auth: {
        username: Rails.application.credentials.spreedly[:env_key],
        password: ENV['SPREEDLY_SECRET']
      },
      headers: {
        'Content-Type' => 'application/json'
      },
      body: {
        delivery: {
          payment_method_token: payment_method_token,
          amount: amount_in_cents,
          currency_code: CURRENCY_CODE,
          url: RECEIVER_URL,
          body: {
            destination: destination,
            card_number: '{{credit_card_number}}'
          }
        }
      }.to_json
    )
  end
end
