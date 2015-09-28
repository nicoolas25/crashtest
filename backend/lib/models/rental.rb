require_relative "../errors"

Rental = Struct.new(:id, :car_id, :start_date, :end_date, :distance, :deductible_reduction) do

  attr_accessor :car

  def driver_debit
    deductible_reduction_price + price
  end

  def owner_credit
    driver_debit - insurance_credit - assistance_credit - drivy_credit
  end

  def insurance_credit
    (commission * 0.5).to_i
  end

  def assistance_credit
    duration * 100
  end

  def drivy_credit
    deductible_reduction_price +
      (commission - insurance_credit - assistance_credit).to_i
  end

  private

  def price
    price_per_all_days + price_per_all_kms
  end

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

  def deductible_reduction_price
    if deductible_reduction
      400 * duration
    else
      0
    end
  end

end
