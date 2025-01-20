require 'rails_helper'

RSpec.describe 'Create a Coupon', type: :request do
  describe 'POST /api/v1/merchants/:merchant_id/coupons' do
    it 'creates a new coupon with valid attributes' do
      merchant = Merchant.create!(name: 'Wally-World')

      coupon_params = { name: 'BOGO', unique_code: 'BOGO123', percent_off: 0.5, dollar_off: nil }

      post "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}", params: { coupon: coupon_params }

      expect(response).to have_http_status(200)
      coupon_response = JSON.parse(response.body, symbolize_names: true)
      expect(coupon_response[:coupon][:data][:attributes][:name]).to eq('BOGO')
      expect(coupon_response[:coupon][:data][:attributes][:unique_code]).to eq('BOGO123')
    end

    it 'does not create a new coupon with invalid attributes' do
      merchant = Merchant.create!(name: 'Wally-World')

      invalid_coupon_params = { name: '', unique_code: 'BOGO123', percent_off: 0.5, dollar_off: nil }

      post "/api/v1/merchants/#{merchant.id}/coupons", params: { coupon: invalid_coupon_params }

      expect(response).to have_http_status(422)  
      
      error_response = JSON.parse(response.body, symbolize_names: true)
      expect(error_response[:errors]).to include("Name can't be blank")
    end
  end
end