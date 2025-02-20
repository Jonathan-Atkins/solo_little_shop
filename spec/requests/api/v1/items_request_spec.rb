require 'rails_helper'

RSpec.describe "Little Shop API", type: :request do    
  it "can update an item" do
    # Create a merchant since the item belongs to a merchant
    test_merchant = Merchant.create!(name: "Test Merchant")
    
    # Create an initial item to test updates
    test_item_1 = Item.create!(
      name: "Old Item Name",
      description: "Old description of the item.",
      unit_price: 50.00,
      merchant_id: test_merchant.id
    )
    # Define the update parameters
    updated_attributes = {
    name: "Shiny NEW Itemy",
    description: "It does a lot of new things!",
    unit_price: 65.23
    }
    # Send a PATCH request to update the item
    put "/api/v1/items/#{test_item_1.id}", params: { item: updated_attributes }

    # Reload the item to reflect updated changes
    test_item_1.reload

    # Expect the response to return the correct updated attributes
    expect(response).to be_successful
    expect(test_item_1.name).to eq(updated_attributes[:name])
    expect(test_item_1.description).to eq(updated_attributes[:description])
    expect(test_item_1.unit_price).to eq(updated_attributes[:unit_price])
  end


  it "can get a merchant by item id" do
    # Create a merchant since the item belongs to a merchant
    test_merchant = Merchant.create!(name: "Test Merchant")
    
    # Create an initial item to ensure we're getting the correct merchant
    test_item_1 = Item.create!(
    name: "Old Item Name",
    description: "Old description of the item.",
    unit_price: 50.00,
    merchant_id: test_merchant.id
  )
   
    # Send a GET request to get the merchant data
    get "/api/v1/items/#{test_item_1.id}/merchant"

    expect(response).to be_successful

    the_merchant = JSON.parse(response.body, symbolize_names: true)
    expect(the_merchant[:data][:attributes][:name]).to eq("Test Merchant") 
  end

  it "will gracefully handle if a Item id doesn't exist" do
    test_merchant = Merchant.create!(name: "Test Merchant")
    
    test_item_1 = Item.create!(
    name: "Old Item Name",
    description: "Old description of the item.",
    unit_price: 50.00,
    merchant_id: test_merchant.id
    )

    get "/api/v1/items/3423978540937t3908275394087290457/merchant"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    expect(data[:errors]).to eq(["Item not found"])
  end 

  it "will gracefully handle if Merchant has no items" do

    get "/api/v1/merchants/98989/items"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    error = JSON.parse(response.body, symbolize_names: true)[:error][0][:title]
    expect(error).to eq("Couldn't find Merchant with 'id'=98989")
  end
end