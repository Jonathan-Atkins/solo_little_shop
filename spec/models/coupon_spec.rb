require 'rails_helper'

describe Coupon, type: :model do
  describe "relationships" do
    it { should belong_to  :merchant }
    it { should have_many  :invoices }
  end

  describe "validations" do
    it "can validate attributes" do

      merchant1 = Merchant.create!(name: 'Amazon')
      
      coupon = Coupon.create!(name: 'Buy One Get One', unique_code: 'BOGO', percent_off: 0.5, merchant_id: merchant1.id)
      
      expect(coupon).to be_valid
      
      coupon = Coupon.create!(name: 'Half Off', unique_code: 'HALFO', dollar_off: 5.00, merchant_id: merchant1.id)

      expect(coupon).to be_valid
      expect(coupon.name).to eq('Half Off')
      expect(coupon.unique_code).to eq('HALFO')
      expect(coupon.dollar_off).to eq(5.00)
      expect(coupon.merchant_id).to eq(merchant1.id)
    end
  end
end