require 'rails_helper'

describe Coupon, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many  :invoices }
  end

  describe "validations" do
    it "can validate attributes" do

      merchant1 = Merchant.create!(name: 'Amazon')
      
      coupon = Coupon.create!(name: 'Buy One Get One', unique_code: 'BOGO', percent_off: 0.5, merchant_id: merchant1.id)
      
      expect(coupon).to be_valid
      
      coupon = Coupon.create!(name: 'Half Off', unique_code: 'HO', dollar_off: 5.00, merchant_id: merchant1.id)

      expect(coupon).to be_valid
    end
  end
end