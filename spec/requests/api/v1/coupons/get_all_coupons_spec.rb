    # Updated to include `merchant_id` in the route
    require 'rails_helper'

    RSpec.describe "Coupons", type: :request do
      it "can get all coupons" do
        merchant1 = Merchant.create!(name: 'Amazon') 
        coupon1 = Coupon.create!(name: 'Buy One Get One', unique_code: 'BOGO', percent_off: 0.5, merchant_id: merchant1.id)
        coupon2 = Coupon.create!(name: '10% Off', unique_code: 'TENOFF', percent_off: 0.1, merchant_id: merchant1.id)
        coupon3 = Coupon.create!(name: '20% Off', unique_code: 'TWENTYOFF', percent_off: 0.2, merchant_id: merchant1.id)
        coupon4 = Coupon.create!(name: 'Free Shipping', unique_code: 'FREESHIP', percent_off: 0.0, merchant_id: merchant1.id)
        coupon5 = Coupon.create!(name: '15% Off Orders Over $50', unique_code: 'FIFTEEN50', percent_off: 0.15, merchant_id: merchant1.id)
    
        get "/api/v1/merchants/#{merchant1.id}/coupons"
    
        expect(response).to be_successful
        expect(response.status).to eq(200)
    
        coupons = JSON.parse(response.body, symbolize_names: true)

        expect(coupons[:data].count).to eq(5)
      end
    end