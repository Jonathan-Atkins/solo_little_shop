require 'rails_helper'

describe Coupon, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoices }
  end

  describe "validations" do
    it "can validate attributes" do
      merchant1 = Merchant.create!(name: 'Amazon')
      coupon = Coupon.create!(name: 'Buy One Get One', unique_code: 'BOGO', percent_off: 0.5, merchant_id: merchant1.id)

      expect(coupon).to be_valid
      expect(coupon.id).to be_present
      expect(coupon.name).to eq('Buy One Get One')
      expect(coupon.unique_code).to eq('BOGO')
      expect(coupon.active).to eq(true)
      expect(coupon.percent_off).to eq(0.5)
      expect(coupon.used_count).to eq(0)
      expect(coupon.merchant_id).to eq(merchant1.id)
    end
  end

  # describe "#apply_coupon" do
  #   it "should deactivate the coupon if used_count exceeds 5" do
  #     merchant1 = Merchant.create!(name: 'Amazon')
  #     coupon = Coupon.create!(name: 'BOGO', unique_code: 'BOGO123', percent_off: 0.5, merchant_id: merchant1.id)
  #     customer = Customer.create!(first_name: 'John', last_name: 'Doe')
    
  #     6.times do |i|
  #       invoice = Invoice.new(customer: customer, merchant: merchant1, status: 'pending')
  #       invoice.apply_coupon(coupon)
  #       puts "Invoice #{i+1}: Coupon applied, used_count: #{coupon.used_count}"
  #       coupon.reload
  #     end

  #     expect(coupon.active).to be_falsey
  #     expect(coupon.used_count).to eq(6)
  #   end

  #   it "should not deactivate the coupon if used_count is less than or equal to 5" do
  #     merchant1 = Merchant.create!(name: 'Amazon')
  #     coupon = Coupon.create!(name: 'BOGO', unique_code: 'BOGO123', percent_off: 0.5, merchant_id: merchant1.id)
  #     customer = Customer.create!(first_name: 'John', last_name: 'Doe')
      
  #     invoice = Invoice.new(customer: customer, merchant: merchant1, status: 'pending')
      
  #     invoice.apply_coupon(coupon)
  #     coupon.reload
  #     expect(coupon.used_count).to eq(5)
  #   end
  # end

  describe "instance methods" do
    before :each do
      @merchant = Merchant.create!(name: "Merchant One")
      @coupon1 = @merchant.coupons.create!(name: "10% Off", unique_code: "TENOFF", percent_off: 0.1)
      @coupon2 = @merchant.coupons.create!(name: "20% Off", unique_code: "TWENTYOFF", percent_off: 0.2)
      @coupon3 = @merchant.coupons.create!(name: "coup3", unique_code: "TENOFF1", percent_off: 0.1)
      @coupon4 = @merchant.coupons.create!(name: "coup4", unique_code: "TWENTYOFF2", percent_off: 0.2)
      @item1 = @merchant.items.create!(name: "Item 1", unit_price: 10.0)
      @item2 = @merchant.items.create!(name: "Item 2", unit_price: 20.0)
    end

    it "it limits merchants to 5 active coupons" do
      merchant2 = Merchant.create!(name: "Amazon")
      4.times { |t| merchant2.coupons.create!(name: "coupon#{t+1}", unique_code: "TENOFF-#{t+1}", percent_off: 0.1)}

      coupon5   = merchant2.coupons.create!(name: "coup5", unique_code: "TWENTYOFF5", percent_off: 0.2)
      coupon6   = merchant2.coupons.build(name: "coup6", unique_code: "TWENTYOFF6", percent_off: 0.2)

      expect(coupon6.valid?).to be false
      expect(coupon6.errors[:base]).to include("Merchants can only have 5 active coupons at one time")
    end
  end
end