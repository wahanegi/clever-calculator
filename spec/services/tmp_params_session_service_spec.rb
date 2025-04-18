require "rails_helper"

RSpec.describe TmpParamsSessionService do
  let(:session) { {} }
  let(:item_key) { "123" }
  let(:service) { described_class.new(session, item_key) }

  describe "#set and #get" do
    it "returns nil for unset keys" do
      expect(service.get(:nonexistent)).to be_nil
    end

    it "sets and retrieves a hash value with symbolized keys" do
      service.set(:fixed, { "Weight" => "5kg" })
      expect(service.get(:fixed)).to eq({ Weight: "5kg" })
      expect(session[:tmp_params][item_key]).to include("fixed" => { "Weight" => "5kg" })
    end
  end

  describe "#all" do
    it "returns the full session data for item" do
      service.set(:open, ["Size"])
      expect(service.all).to include("open" => ["Size"])
    end
  end

  describe "#delete" do
    it "removes the item data from session" do
      service.set(:open, ["A"])
      expect { service.delete }.to change { session[:tmp_params].key?(item_key) }.from(true).to(false)
    end
  end

  describe "Formula Parameters management" do
    before { service.set(:formula_parameters, []) }

    it "adds unique formula parameters" do
      service.add_formula_parameter("Size")
      service.add_formula_parameter("Size")
      expect(service.get(:formula_parameters)).to eq(["Size"])
    end

    it "supports multiple parameters" do
      service.add_formula_parameter("A")
      service.add_formula_parameter("B")
      expect(service.get(:formula_parameters)).to match_array(%w[A B])
    end

    it "removes existing formula parameters" do
      service.add_formula_parameter("X")
      service.remove_formula_parameter("X")
      expect(service.get(:formula_parameters)).to eq([])
    end

    it "does nothing when removing a non-existent parameter" do
      service.remove_formula_parameter("Nonexistent")
      expect(service.get(:formula_parameters)).to be_empty
    end
  end

  describe "#store_meta" do
    it "stores name, description, and category_id in session" do
      service.store_meta(name: "Test", description: "Desc", category_id: 1)

      expect(service.get(:name)).to eq("Test")
      expect(service.get(:description)).to eq("Desc")
      expect(service.get(:category_id)).to eq(1)
    end
  end

  describe "#update_with_tmp_to_item" do
    context "when session contains data" do
      before do
        service.set(:fixed, { "X" => "1" })
        service.set(:open, ["Y"])
        service.set(:select, { "Z" => { "options" => { "A" => "10" }, "value_label" => "Qty" } })
        service.set(:formula_parameters, %w[X Y])
        service.set(:calculation_formula, "X + Y")
      end

      it "applies session data to an item and sets flags correctly" do
        item = Item.new
        service.update_with_tmp_to_item(item)

        expect(item.fixed_parameters).to eq({ "X" => "1" })
        expect(item.open_parameters_label).to eq(["Y"])
        expect(item.pricing_options).to eq({ "Z" => { "options" => { "A" => "10" }, "value_label" => "Qty" } })
        expect(item.formula_parameters).to eq(%w[X Y])
        expect(item.calculation_formula).to eq("X + Y")
        expect(item.is_fixed).to be true
        expect(item.is_open).to be true
        expect(item.is_selectable_options).to be true
      end
    end

    context "when no session data is present" do
      it "sets default empty values and flags to false" do
        item = Item.new
        service.update_with_tmp_to_item(item)

        expect(item.fixed_parameters).to eq({})
        expect(item.open_parameters_label).to eq([])
        expect(item.pricing_options).to eq({})
        expect(item.formula_parameters).to eq([])
        expect(item.calculation_formula).to be_nil

        expect(item.is_fixed).to be false
        expect(item.is_open).to be false
        expect(item.is_selectable_options).to be false
      end
    end
  end
end
