require "models/action"

RSpec.describe Action do
  let(:action) { described_class.new("drivy", previous, current) }

  subject(:amount) { action.amount }
  subject(:type) { action.type }

  context "when previous < current amount" do
    let(:previous) { 600 }
    let(:current) { 1000 }

    describe "#amount" do
      it { expect(amount).to eq 400 }
    end

    describe "#type" do
      it { expect(type).to eq "credit" }
    end
  end

  context "when previous > current amount" do
    let(:previous) { 1000 }
    let(:current) { 600 }

    describe "#amount" do
      it { expect(amount).to eq 400 }
    end

    describe "#type" do
      it { expect(type).to eq "debit" }
    end
  end
end
