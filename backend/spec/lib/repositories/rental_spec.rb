require "repositories/rental_repository"

RSpec.describe RentalRepository do
  describe ".load" do
    subject(:load_hashes) { repository.load(rental_hashes, dependencies) }

    it "add Cars instances into the repository" do
      load_hashes
      expect(repository.fetch(1)).to be_a Rental
    end

    context "when an attribute is missing from a rental hash" do
      before { rental_hashes.first.delete("car_id") }

      it "raises a KeyError" do
        expect { load_hashes }.to raise_error(KeyError)
      end
    end

    context "when multiple car share the same id" do
      before { rental_hashes.map { |hash| hash["id"] = 1 } }

      it "raises a DuplicateIdError" do
        expect { load_hashes }.to raise_error(DuplicateIdError)
      end
    end

    context "when a dependency is missing" do
      before { rental_hashes.first["car_id"] = 3 }

      it "raises a KeyError" do
        expect { load_hashes }.to raise_error(KeyError)
      end
    end

    let(:rental_hashes) do
      [
        {
          "id" => 1,
          "car_id" => 1,
          "start_date" => "2017-12-8",
          "end_date" => "2017-12-10",
          "distance" => 100,
        },
        {
          "id" => 2,
          "car_id" => 1,
          "start_date" => "2017-12-20",
          "end_date" => "2017-12-20",
          "distance" => 200,
        },
      ]
    end

    let(:dependencies) { { cars: cars } }
    let(:cars) { { 1 => car, 2 => car } }
    let(:car) { double("Car", price_per_day: 100, price_per_km: 1) }
  end

  let(:repository) { described_class.new }
end
