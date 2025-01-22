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
    expect(coupons[:data][0][:id]).to eq(coupon1.id.to_s)
    expect(coupons[:data][0][:attributes][:name]).to eq('Buy One Get One')
    
    expect(coupons[:data][1][:id]).to eq(coupon2.id.to_s)
    expect(coupons[:data][1][:attributes][:name]).to eq('10% Off')
    
    expect(coupons[:data][2][:id]).to eq(coupon3.id.to_s)
    expect(coupons[:data][2][:attributes][:name]).to eq('20% Off')
    
    expect(coupons[:data][3][:id]).to eq(coupon4.id.to_s)
    expect(coupons[:data][3][:attributes][:name]).to eq('Free Shipping')
    
    expect(coupons[:data][4][:id]).to eq(coupon5.id.to_s)
    expect(coupons[:data][4][:attributes][:name]).to eq('15% Off Orders Over $50')
  end

  it "can sort by active status" do
    merchant1 = Merchant.create!(name: 'Amazon') 
    coupon1 = Coupon.create!(name: 'Buy One Get One', unique_code: 'BOGO', percent_off: 0.5, merchant_id: merchant1.id, active: false)
    coupon2 = Coupon.create!(name: '10% Off', unique_code: 'TENOFF', percent_off: 0.1, merchant_id: merchant1.id)
    coupon3 = Coupon.create!(name: '20% Off', unique_code: 'TWENTYOFF', percent_off: 0.2, merchant_id: merchant1.id)
    coupon4 = Coupon.create!(name: 'Free Shipping', unique_code: 'FREESHIP', percent_off: 0.0, merchant_id: merchant1.id)
    coupon5 = Coupon.create!(name: '15% Off Orders Over $50', unique_code: 'FIFTEEN50', percent_off: 0.15, merchant_id: merchant1.id, active: false)

    get "/api/v1/merchants/#{merchant1.id}/coupons", params: { active: 'true' }

    coupons = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(coupons.count).to eq(3)
    expect(coupons.first[:id].to_i).to eq(coupon2.id)
  end

  it "can sort by inactive status" do
    merchant1 = Merchant.create!(name: 'Amazon') 
    coupon1 = Coupon.create!(name: 'Buy One Get One', unique_code: 'BOGO', percent_off: 0.5, merchant_id: merchant1.id, active: false)
    coupon2 = Coupon.create!(name: '10% Off', unique_code: 'TENOFF', percent_off: 0.1, merchant_id: merchant1.id)
    coupon3 = Coupon.create!(name: '20% Off', unique_code: 'TWENTYOFF', percent_off: 0.2, merchant_id: merchant1.id)
    coupon4 = Coupon.create!(name: 'Free Shipping', unique_code: 'FREESHIP', percent_off: 0.0, merchant_id: merchant1.id)
    coupon5 = Coupon.create!(name: '15% Off Orders Over $50', unique_code: 'FIFTEEN50', percent_off: 0.15, merchant_id: merchant1.id, active: false)

    get "/api/v1/merchants/#{merchant1.id}/coupons", params: { active: 'false' }

    coupons = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(coupons.count).to eq(2)
  end

  it "returns a message if merchant has no coupons" do
    merchant = Merchant.create!(name: 'Wally-World')

    get "/api/v1/merchants/#{merchant.id}/coupons"

    expect(response).to have_http_status(200)
    message_response = JSON.parse(response.body, symbolize_names: true)
    expect(message_response[:message]).to eq("#{merchant.name} has no coupons")
  end

  it "returns an empty array when no active coupons are found" do
    merchant = Merchant.create!(name: 'Wally-World')
    coupon = merchant.coupons.create!(name: 'BOGO', unique_code: 'BOGO123', percent_off: 0.5, active: false)

    get "/api/v1/merchants/#{merchant.id}/coupons", params: { active: 'true' }

    expect(response).to have_http_status(200)
    coupons = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(coupons).to eq([])
  end

  describe "Sad Paths" do
    it "can fail if merchant does not exist" do
      get "/api/v1/merchants/8000/coupons"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      error = JSON.parse(response.body, symbolize_names: true)[:error]

      expect(error[0][:title]).to eq("Couldn't find Merchant with 'id'=8000")
    end
  end
end