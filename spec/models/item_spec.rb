require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
  end

  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "class methods" do
    before :each do
      @merchant = Merchant.create!(name: "Merchant One")
      @item1 = Item.create!(name: "Widget", unit_price: 10.00, merchant: @merchant)
      @item2 = Item.create!(name: "Gadget", unit_price: 20.00, merchant: @merchant)
      @item3 = Item.create!(name: "Super Widget", unit_price: 30.00, merchant: @merchant)
    end

    describe ".find_by_name" do
      it "returns items that match the name, case-insensitively" do
        result = Item.find_by_name("widget")
        expect(result).to include(@item1, @item3)
        expect(result).not_to include(@item2)
      end
    end

    describe ".find_by_price" do
      context "when searching by min_price" do
        it "returns items with a unit_price greater than or equal to the given price" do
          result = Item.find_by_price(20, :min_price)
          expect(result).to include(@item2, @item3)
          expect(result).not_to include(@item1)
        end
      end

      context "when searching by max_price" do
        it "returns items with a unit_price less than or equal to the given price" do
          result = Item.find_by_price(20, :max_price)
          expect(result).to include(@item1, @item2)
          expect(result).not_to include(@item3)
        end
      end
    end
  end
end