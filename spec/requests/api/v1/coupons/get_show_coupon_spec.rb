require 'rails_helper'

RSpec.describe "Show Coupons", type: :request do
  describe "it can return coupon attributes" do
    it "returns a specific coupon by its ID" do
      merchant = Merchant.create!(name: 'Wally-World')

      coupon1 = Coupon.create!(name: 'Buy One Get One', unique_code: 'BOGO', percent_off: 0.5, merchant_id: merchant.id)
      coupon2 = Coupon.create!(name: '10% Off', unique_code: 'TENOFF', percent_off: 0.1, merchant_id: merchant.id)
      coupon3 = Coupon.create!(name: '20% Off', unique_code: 'TWENTYOFF', percent_off: 0.2, merchant_id: merchant.id)
      coupon4 = Coupon.create!(name: 'Free Shipping', unique_code: 'FREESHIP', percent_off: 0.0, merchant_id: merchant.id)
      coupon5 = Coupon.create!(name: '15% Off Orders Over $50', unique_code: 'FIFTEEN50', percent_off: 0.15, merchant_id: merchant.id)
      
      get "/api/v1/coupons/#{coupon1.id}"
      
      expect(response).to be_successful
      expect(response.status).to eq(200)

      coupon_response = JSON.parse(response.body, symbolize_names: true)

      attrs = coupon_response[:data][:attributes]

      expect(attrs[:name]).to eq('Buy One Get One')
    end

    it "can count how many times a coupon is used" do

      merchant = Merchant.create!(name: 'Wally-World')

      coupon1 = Coupon.create!(name: '10% Off', unique_code: 'TENOFF', percent_off: 0.1, merchant_id: merchant.id)

      customer = Customer.create!(first_name: 'Jane', last_name: 'Doe')
      invoice1 = Invoice.create!(customer: customer, merchant: merchant, coupon: coupon1)
      invoice2 = Invoice.create!(customer: customer, merchant: merchant, coupon: coupon1)
      invoice3 = Invoice.create!(customer: customer, merchant: merchant, coupon: coupon1)

      get "/api/v1/coupons/#{coupon1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      coupon_response = JSON.parse(response.body, symbolize_names: true)
      
      expect(coupon_response[:data][:attributes][:used_count]).to eq(3)
      
    end

  describe "Sad Paths" do
    it "returns 404 if the coupon does not exist" do
      get "/api/v1/coupons/78945"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)[:error]
      expect(error.first[:title]).to eq("Couldn't find Coupon with 'id'=78945")
    end
  end
  end
end