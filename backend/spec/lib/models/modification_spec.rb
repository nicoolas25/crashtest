require "models/car"
require "models/rental"
require "models/modification"

RSpec.describe Modification do
  describe "#actions" do
    subject(:actions) { modification.actions }

    shared_examples "keeping the balance" do
      it "keeps the balance between debit and credit" do
        credit = actions
          .select { |action| action.type == "credit" }
          .map(&:amount)
          .inject(0, &:+)
        debit = actions
          .select { |action| action.type == "debit" }
          .map(&:amount)
          .inject(0, &:+)
        expect(credit - debit).to eq 0
      end
    end

    it { is_expected.to be_an Array }

    it "returns one action per actor" do
      expected_actors = %w(driver owner insurance assistance drivy)
      expect(actions.map(&:actor)).to match_array expected_actors
    end

    include_examples "keeping the balance"

    context "when the modification doesn't change anything" do
      it "returns actions with 0 as amount and credit as type" do
        actions.each do |action|
          expect(action.type).to eq "credit"
          expect(action.amount).to eq 0
        end
      end

      include_examples "keeping the balance"
    end

    context "when the distance increase" do
      let(:new_distance) { 200 }

      include_examples "keeping the balance"

      it "create a new debit for the driver" do
        expect(action_for("driver").type).to eq "debit"
        expect(action_for("driver").amount).to eq 1000
      end

      it "split the credit to the other actors except for the assistance" do
        expect(action_for("owner").type).to eq "credit"
        expect(action_for("owner").amount).to eq 700

        expect(action_for("insurance").type).to eq "credit"
        expect(action_for("insurance").amount).to eq 150

        expect(action_for("drivy").type).to eq "credit"
        expect(action_for("drivy").amount).to eq 150
      end
    end

    context "when the distance decrease" do
      let(:new_distance) { 50 }

      include_examples "keeping the balance"

      it "create a new credit for the driver" do
        expect(action_for("driver").type).to eq "credit"
        expect(action_for("driver").amount).to eq 500
      end

      it "split the debit to the other actors except for the assistance" do
        expect(action_for("owner").type).to eq "debit"
        expect(action_for("owner").amount).to eq 350

        expect(action_for("insurance").type).to eq "debit"
        expect(action_for("insurance").amount).to eq 75

        expect(action_for("drivy").type).to eq "debit"
        expect(action_for("drivy").amount).to eq 75
      end
    end

    context "when the timeframe increase" do
      let(:new_end_date) { "2015-02-16" }

      include_examples "keeping the balance"

      it "create a new debit for the driver" do
        expect(action_for("driver").type).to eq "debit"
        expect(action_for("driver").amount).to eq 2100
      end

      it "split the credit to the other actors" do
        expect(action_for("owner").type).to eq "credit"
        expect(action_for("owner").amount).to eq 1470

        expect(action_for("insurance").type).to eq "credit"
        expect(action_for("insurance").amount).to eq 315

        expect(action_for("assistance").type).to eq "credit"
        expect(action_for("assistance").amount).to eq 100

        expect(action_for("drivy").type).to eq "credit"
        expect(action_for("drivy").amount).to eq 215
      end
    end

    context "when the timeframe decrease" do
      let(:new_end_date) { "2015-02-14" }

      include_examples "keeping the balance"

      it "create a new credit for the driver" do
        expect(action_for("driver").type).to eq "credit"
        expect(action_for("driver").amount).to eq 2100
      end

      it "split the credit to the other actors" do
        expect(action_for("owner").type).to eq "debit"
        expect(action_for("owner").amount).to eq 1470

        expect(action_for("insurance").type).to eq "debit"
        expect(action_for("insurance").amount).to eq 315

        expect(action_for("assistance").type).to eq "debit"
        expect(action_for("assistance").amount).to eq 100

        expect(action_for("drivy").type).to eq "debit"
        expect(action_for("drivy").amount).to eq 215
      end
    end

    context "when both the timeframe increase and the distance decrease" do
      let(:new_end_date) { "2015-02-16" }
      let(:new_distance) { 50 }

      include_examples "keeping the balance"

      it "create a new debit for the driver" do
        expect(action_for("driver").type).to eq "debit"
        expect(action_for("driver").amount).to eq 1600
      end

      it "split the credit to the other actors" do
        expect(action_for("owner").type).to eq "credit"
        expect(action_for("owner").amount).to eq 1120

        expect(action_for("insurance").type).to eq "credit"
        expect(action_for("insurance").amount).to eq 240

        expect(action_for("assistance").type).to eq "credit"
        expect(action_for("assistance").amount).to eq 100

        expect(action_for("drivy").type).to eq "credit"
        expect(action_for("drivy").amount).to eq 140
      end
    end

    context "when both the timeframe decrease and the distance increase" do
      let(:new_end_date) { "2015-02-14" }
      let(:new_distance) { 400 }

      include_examples "keeping the balance"

      it "create a new debit for the driver because the distance increase a lot" do
        expect(action_for("driver").type).to eq "debit"
        expect(action_for("driver").amount).to eq 900
      end

      it "split the credit to the other actors" do
        expect(action_for("owner").type).to eq "credit"
        expect(action_for("owner").amount).to eq 630

        expect(action_for("insurance").type).to eq "credit"
        expect(action_for("insurance").amount).to eq 135

        expect(action_for("assistance").type).to eq "debit"
        expect(action_for("assistance").amount).to eq 100

        expect(action_for("drivy").type).to eq "credit"
        expect(action_for("drivy").amount).to eq 235
      end
    end
  end

  let(:modification) do
    Modification.new(1, 1, new_start_date, new_end_date, new_distance).tap do |mod|
      mod.rental = Rental.new(1, 1, "2015-02-10", "2015-02-15", 100, false)
      mod.rental.car = Car.new(1, 3000, 10)
    end
  end

  let(:new_start_date) { "2015-02-10" }
  let(:new_end_date) { "2015-02-15" }
  let(:new_distance) { 100 }

  def action_for(actor)
    actions.find { |action| action.actor == actor }
  end

end
