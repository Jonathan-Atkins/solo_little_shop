require 'rails_helper'

RSpec.describe "Coupons API", type: :request do
  describe "GET /api/v1/coupons/:id" do
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

      expect(coupon_response[:data][:id]).to eq(coupon1.id.to_s)
      expect(coupon_response[:data][:attributes][:name]).to eq('Buy One Get One')
    end

    describe "Sad Paths" do
      it "returns 404 if the coupon does not exist" do
        get "/api/v1/coupons/78945"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        error = JSON.parse(response.body, symbolize_names: true)[:error]
        expect(error[:title]).to eq("Couldn't find Coupon with 'id'=78945")
      end
    end
  end
end