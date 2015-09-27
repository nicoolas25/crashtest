require "models/rental"

RSpec.describe Rental do
  describe "#price" do
    subject(:price) { rental.price }

    context "when the duration is one day" do
      let(:end_date) { start_date }
      it { is_expected.to eq 1050 }
    end

    context "when the duration is two days" do
      let(:end_date) { "2015-09-30" }
      it { is_expected.to eq 1950 }
      # 50 + 1000 + (1 * 1000 * 0.9)
    end

    context "when the duration is ten days" do
      let(:end_date) { "2015-10-08" }
      it { is_expected.to eq 7950 }
      # 50 + 1000 + (3 * 1000 * 0.9) + (6 * 1000 * 0.7)
    end

    context "when the duration is twenty days" do
      let(:end_date) { "2015-10-18" }
      it { is_expected.to eq 12950 }
      # 50 + 1000 + (3 * 1000 * 0.9) + (6 * 1000 * 0.7) + (10 * 1000 * 0.5)
    end

    context "when the end_date is before the start date" do
      let(:end_date) { "2015-09-28" }

      it "raises a RentalDurationError" do
        expect { price }.to raise_error(RentalDurationError)
      end
    end
  end

  describe "#insurance_fee" do
    subject(:insurance_fee) { rental.insurance_fee }
    it { is_expected.to eq (rental.price * 0.3 * 0.5) }
  end

  describe "#assistance_fee" do
    subject(:assistance_fee) { rental.assistance_fee }
    it { is_expected.to eq 500 }
  end

  describe "#drivy_fee" do
    subject(:drivy_fee) { rental.drivy_fee }
    it { is_expected.to eq (rental.price * 0.3 * 0.5 - rental.assistance_fee) }
  end

  let(:rental) do
    Rental.new(1, 1, start_date, end_date, distance).tap do |rental|
      rental.car = car
    end
  end

  let(:car) { double("Car", price_per_day: 1000, price_per_km: 1) }
  let(:start_date) { "2015-09-29" }
  let(:end_date) { "2015-10-03" }
  let(:distance) { 50 }
end
