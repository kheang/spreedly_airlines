class FlightsController < ApplicationController
  def index
    @flights = flights
  end

  private

  def flights
    session[:flights] = [
      { destination: 'CLT', price: 150 },
      { destination: 'LGA', price: 200 },
      { destination: 'SFO', price: 500 }
    ]
    session[:flights].map { |flight_attributes| Flight.new(flight_attributes.symbolize_keys) }
  end
end
