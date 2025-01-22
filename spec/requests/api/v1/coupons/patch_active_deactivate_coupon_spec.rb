require 'rails_helper'

RSpec.describe 'Updates a Coupon', type: :request do
  describe 'PATCH /api/v1/merchants/:merchant_id/coupons/:id' do
    it 'deactivates a coupon when active is true' do
      merchant = Merchant.create!(name: 'Wally-World')
      coupon = merchant.coupons.create!(name: 'BOGO', unique_code: 'BOGO123', percent_off: 0.5, dollar_off: nil, active: true)

      patch "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}", params: {active: false}

      expect(response).to have_http_status(200)

      message_response = JSON.parse(response.body, symbolize_names: true)
      expect(message_response[:message]).to eq("#{coupon.name} is now inactive")

      coupon.reload  
      expect(coupon.active).to eq(false)  
    end

    it 'activates a coupon when active is false' do
      merchant = Merchant.create!(name: 'Wally-World')
      coupon = merchant.coupons.create!(name: 'BOGO', unique_code: 'BOGO123', percent_off: 0.5, dollar_off: nil, active: false)

      patch "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}", params: {active: true}

      expect(response).to have_http_status(200)

      message_response = JSON.parse(response.body, symbolize_names: true)
      expect(message_response[:message]).to eq("#{coupon.name} is now active")

      coupon.reload 
      expect(coupon.active).to eq(true)  
    end
  end
end
