require 'rails_helper'

RSpec.describe "Create a Coupon", type: :request do
  it "can create a new coupon" do
    coupon = Coupon.create!()

    post "/api/v1/merchants",params: merchant_name 

    expect(response).to be_successful
    expect(response.status).to eq(201)
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:attributes][:name]).to eq('Amazon')
  end

  describe "Sad Paths" do
    it "returns an error if the name is missing" do
      invalid_params = { name: "" }

      post "/api/v1/merchants", params: invalid_params

      expect(response).not_to be_successful
      expect(response.status).to eq(422)
      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to eq(["unprocessable entity"])
    end
  end
end