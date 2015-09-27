require_relative "../errors"

Rental = Struct.new(:id, :car_id, :start_date, :end_date, :distance) do

  attr_accessor :car

  def price
    price_per_all_days + price_per_all_kms
  end

  def insurance_fee
    commission * 0.5
  end

  def assistance_fee
    duration * 100
  end

  def drivy_fee
    commission - insurance_fee - assistance_fee
  end

  private

  def price_per_all_kms
    distance * car.price_per_km
  end

  def price_per_all_days
    (1..duration).to_a.map { |day| price_for_day(day) }.inject(&:+)
  end

  def price_for_day(day)
    case day
    when 1     then car.price_per_day
    when 2..4  then car.price_per_day * 0.9
    when 5..10 then car.price_per_day * 0.7
    else            car.price_per_day * 0.5
    end.to_i
  end

  def duration
    day_diff = Date.parse(end_date) - Date.parse(start_date)
    raise RentalDurationError.new(self) if day_diff < 0
    day_diff.to_i + 1
  end

  def commission
    price * 0.3
  end

end
