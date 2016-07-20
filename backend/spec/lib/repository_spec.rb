require "repository"

RSpec.describe Repository do
  describe "#load" do
    subject(:load_hashes) { repository.load(hashes) }

    it "add instances into the repository" do
      load_hashes
      expect(repository.fetch(1)).to be_a klass
    end

    context "when an attribute is missing from the hash" do
      before { hashes.first.delete("missing") }

      it "raises a KeyError" do
        expect { load_hashes }.to raise_error(KeyError)
      end
    end

    context "when multiple instances share the same id" do
      before { hashes.map { |hash| hash["id"] = 1 } }

      it "raises a DuplicateIdError" do
        expect { load_hashes }.to raise_error(DuplicateIdError)
      end
    end

    context "when there is dependecies to load" do
      subject(:load_hashes) { repository.load(hashes, dependencies) }

      it "loads provides a hook to load dependencies" do
        expect(repository).to receive(:load_instance_relations).twice do |instance, **kwargs|
          expect(instance).to be_a klass
          expect(kwargs).to eq dependencies
        end
        load_hashes
      end

      let(:dependencies) { { } }
    end
  end

  describe "#all" do
    subject(:all) { repository.all }

    it { is_expected.to be_an Array }

    it "returns all the loaded entries" do
      expect {
        repository.load(hashes)
      }.to change {
        repository.all.size
      }.from(0).to(2)
    end
  end

  describe "#fetch" do
    subject(:fetch) { repository.fetch(1) }

    context "when the repository don't have any entry with the given ID" do
      it "raises a NtFoundInRepositoryError" do
        expect { fetch }.to raise_error(NotFoundInRepositoryError)
      end
    end

    context "when there is entries in the repository" do
      before { repository.load(hashes) }

      it "returns the element matching the given ID" do
        expect(fetch).to be_a klass
        expect(fetch.id).to eq 1
      end
    end
  end

  let(:hashes) do
    [
      { "id" => 1, "missing" => "foo" },
      { "id" => 2, "missing" => "bar" },
    ]
  end

  let(:klass) { Struct.new(:id, :missing) }

  let(:repository) do
    described_class.model = klass
    described_class.new
  end
end
