class Flight
  attr_reader :destination, :price

  def initialize(destination:, price:)
    @destination = destination
    @price = price
  end
end
