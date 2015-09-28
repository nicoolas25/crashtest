require "repositories/rental_repository"

RSpec.describe RentalRepository do
  describe "#load" do
    subject(:load_hashes) { repository.load(rental_hashes, dependencies) }

    it "adds the dependencies to the rental" do
      load_hashes
      rental = repository.fetch(1)
      expect(rental.car).to eq car
    end

    let(:rental_hashes) do
      [
        {
          "id" => 1,
          "car_id" => 1,
          "start_date" => "2017-12-8",
          "end_date" => "2017-12-10",
          "distance" => 100,
          "deductible_reduction" => true,
        },
      ]
    end

    let(:dependencies) { { cars: { 1 => car } } }
    let(:car) { double("Car") }
  end

  let(:repository) { described_class.new }
end
