require_relative "../errors"

Rental = Struct.new(:id, :car_id, :start_date, :end_date, :distance) do

  attr_accessor :car

  def price
    price_per_day + price_per_km
  end

  private

  def price_per_day
    duration * car.price_per_day
  end

  def price_per_km
    distance * car.price_per_km
  end

  def duration
    day_diff = Date.parse(end_date) - Date.parse(start_date)
    raise RentalDurationError.new(self) if day_diff < 0
    day_diff.to_i + 1
  end

end
