require "repositories/car_repository"

RSpec.describe CarRepository do
  describe ".load" do
    subject(:load_hashes) { repository.load(car_hashes) }

    it "add Cars instances into the repository" do
      load_hashes
      expect(repository.fetch(1)).to be_a Car
    end

    context "when an attribute is missing from a car hash" do
      before { car_hashes.first.delete("price_per_km") }

      it "raises a KeyError" do
        expect { load_hashes }.to raise_error(KeyError)
      end
    end

    context "when multiple car share the same id" do
      before { car_hashes.map { |hash| hash["id"] = 1 } }

      it "raises a DuplicateIdError" do
        expect { load_hashes }.to raise_error(DuplicateIdError)
      end
    end

    let(:car_hashes) do
      [
        { "id" => 1, "price_per_day" => 3000, "price_per_km" => 20 },
        { "id" => 2, "price_per_day" => 2000, "price_per_km" => 40 },
      ]
    end
  end

  let(:repository) { described_class.new }
end
