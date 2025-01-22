require 'rails_helper'

RSpec.describe 'Updates a Coupon', type: :request do
  describe 'it can active/deactivate a coupon' do
    it 'deactivates a coupon to false' do
      merchant = Merchant.create!(name: 'Wally-World')
      coupon = merchant.coupons.create!(name: 'BOGO', unique_code: 'BOGO123', percent_off: 0.5, dollar_off: nil, active: true)

      patch "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"

      expect(response).to have_http_status(200)

      message_response = JSON.parse(response.body, symbolize_names: true)
      expect(message_response[:message]).to eq("#{coupon.name} is now inactive")

      coupon.reload  
      expect(coupon.active).to eq(false)
    end

    it 'activates a coupon to true' do
      merchant = Merchant.create!(name: 'Wally-World')
      coupon = merchant.coupons.create!(name: 'BOGO', unique_code: 'BOGO123', percent_off: 0.5, dollar_off: nil, active: false)

      patch "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"

      expect(response).to have_http_status(200)

      message_response = JSON.parse(response.body, symbolize_names: true)
      expect(message_response[:message]).to eq("#{coupon.name} is now active")

      coupon.reload
      expect(coupon.active).to eq(true)
    end
  end

  describe 'Sad Path', type: :request do
    it "returns an error when the coupon id is invalid" do
      merchant = Merchant.create!(name: 'Wally-World')
      coupon = merchant.coupons.create!(name: 'BOGO', unique_code: 'BOGO123', percent_off: 0.5, active: true)
  
      patch "/api/v1/merchants/#{merchant.id}/coupons/99999"
  
      expect(response).to have_http_status(404)
  
      error_response = JSON.parse(response.body, symbolize_names: true)
      attrs = error_response[:error][0]

      expect(attrs[:status]).to eq("404")
      expect(attrs[:title]).to eq("Couldn't find Coupon with 'id'=99999")
    end
  end
end