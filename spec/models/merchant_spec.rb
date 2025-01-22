require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :invoices }
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:coupons).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "class methods" do
    before :each do
      @merchant1 = Merchant.create!(name: "Merchant One", created_at: 2.days.ago)
      @merchant2 = Merchant.create!(name: "Merchant Two", created_at: 1.day.ago)
      @merchant3 = Merchant.create!(name: "Merchant Three")
    end

    describe ".find_by_name" do
      it "returns the first merchant that matches the given name" do
        expect(Merchant.find_by_name("merchant two")).to eq(@merchant2)
      end
    end

    describe ".sort_by_age" do
      it "returns merchants in descending order of creation" do
        expect(Merchant.sort_by_age).to eq([@merchant3, @merchant2, @merchant1])
      end
    end
  end

  describe "instance methods" do
    before :each do
      @merchant = Merchant.create!(name: "Merchant One")
      @coupon1 = @merchant.coupons.create!(name: "10% Off", unique_code: "TENOFF", percent_off: 0.1)
      @coupon2 = @merchant.coupons.create!(name: "20% Off", unique_code: "TWENTYOFF", percent_off: 0.2)
      @item1 = @merchant.items.create!(name: "Item 1", unit_price: 10.0)
      @item2 = @merchant.items.create!(name: "Item 2", unit_price: 20.0)
    end

    describe "#coupons_count" do
      it "returns the total count of coupons for the merchant" do
        expect(@merchant.coupons_count).to eq(2)
      end
    end

    describe "#invoice_coupon_count" do
      it "returns the total count of invoices with coupons for the merchant" do
        customer = Customer.create!(first_name: "Jane", last_name: "Doe")
        Invoice.create!(merchant: @merchant, customer: customer, coupon: @coupon1)
        Invoice.create!(merchant: @merchant, customer: customer, coupon: @coupon2)
        Invoice.create!(merchant: @merchant, customer: customer)

        expect(@merchant.invoice_coupon_count).to eq(2)
      end
    end
  end
end