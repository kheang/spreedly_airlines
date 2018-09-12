class GetSpreedlyTransactions
  attr_reader :state, :transactions

  BASE_URI = 'https://core.spreedly.com/v1'

  def initialize(state:)
    @state = state
  end

  def run!
    @transactions = transactions_request.
      parsed_response.
      fetch('transactions')
    transactions
  end

  private

  def transactions_request
    HTTParty.get(
      "#{BASE_URI}/gateways/#{ENV['SPREEDLY_GATEWAY_TOKEN']}/transactions.json",
      basic_auth: {
        username: Rails.application.credentials.spreedly[:env_key],
        password: ENV['SPREEDLY_SECRET']
      },
      headers: {
        'Content-Type' => 'application/json'
      },
      query: {
        state: state
      }
    )
  end
end
