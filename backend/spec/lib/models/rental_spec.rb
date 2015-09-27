require "models/rental"

RSpec.describe Rental do
  describe "#price" do
    subject(:price) { rental.price }

    it { is_expected.to eq 5045 }

    context "when the duration is one day" do
      let(:end_date) { start_date }
      it { is_expected.to eq 1045 }
    end

    context "when the end_date is before the start date" do
      let(:end_date) { "2015-09-28" }

      it "raises a RentalDurationError" do
        expect { price }.to raise_error(RentalDurationError)
      end
    end
  end

  let(:rental) do
    Rental.new(1, 1, start_date, end_date, distance).tap do |rental|
      rental.car = car
    end
  end

  let(:car) { double("Car", price_per_day: 1000, price_per_km: 1) }
  let(:start_date) { "2015-09-29" }
  let(:end_date) { "2015-10-03" }
  let(:distance) { 45 }
end
