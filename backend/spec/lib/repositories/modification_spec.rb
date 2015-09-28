require "repositories/modification_repository"

RSpec.describe ModificationRepository do
  describe "#load" do
    subject(:load_hashes) { repository.load(modification_hashes, dependencies) }

    it "adds the dependencies to the modification" do
      load_hashes
      modification = repository.fetch(1)
      expect(modification.rental).to eq rental
    end

    context "when some field is missing" do
      before { modification_hashes.first.delete("distance") }

      it "doesn't raise any error" do
        expect { load_hashes }.to_not raise_error
      end
    end

    let(:modification_hashes) do
      [
        {
          "id" => 1,
          "rental_id" => 1,
          "start_date" => "2017-12-8",
          "end_date" => "2017-12-10",
          "distance" => 100,
        },
      ]
    end

    let(:dependencies) { { rentals: { 1 => rental } } }
    let(:rental) { double("Rental") }
  end

  let(:repository) { described_class.new }
end
