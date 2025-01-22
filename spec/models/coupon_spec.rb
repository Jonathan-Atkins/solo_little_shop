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

  describe "#check_and_update_status" do
    it "should deactivate the coupon if used_count exceeds 5" do
      merchant1 = Merchant.create!(name: 'Amazon')
      coupon = Coupon.create!(name: 'BOGO', unique_code: 'BOGO123', percent_off: 0.5, merchant_id: merchant1.id)
      customer = Customer.create!(first_name: 'John', last_name: 'Doe')
  
      6.times do
        invoice = Invoice.new(customer: customer, merchant: merchant1, status: 'pending')
        invoice.apply_coupon(coupon)
      end

      coupon.reload  
      expect(coupon.active).to be_falsey  
      expect(coupon.used_count).to eq(6)
    end

    it "should not deactivate the coupon if used_count is less than or equal to 5" do
      merchant1 = Merchant.create!(name: 'Amazon')
      coupon = Coupon.create!(name: 'BOGO', unique_code: 'BOGO123', percent_off: 0.5, merchant_id: merchant1.id)
      customer = Customer.create!(first_name: 'John', last_name: 'Doe')

      5.times do
        invoice = Invoice.new(customer: customer, merchant: merchant1, status: 'pending')
        invoice.apply_coupon(coupon)
      end

      coupon.reload
      expect(coupon.active).to be_truthy
      expect(coupon.used_count).to eq(5)
    end
  end
end