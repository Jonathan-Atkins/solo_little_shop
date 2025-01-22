require 'rails_helper'

RSpec.describe "Merchant Invoices", type: :request do
  it "returns invoices with optional coupon id" do
    amazon = Merchant.create!(name: 'Amazon')
    brush  = Item.create!(name: 'Brush', description: 'Big Brush', unit_price: 5.20, merchant_id: amazon.id)
    comb   = Item.create!(name: 'Comb', description: 'Little Comb', unit_price: 6.75, merchant_id: amazon.id) 
    coupon = Coupon.create!(name: 'Buy One Get One', unique_code: 'BOGO', percent_off: 0.5, merchant_id: amazon.id)
    parker = Customer.create!(first_name: "Parker", last_name: "Daugherty")
  
    invoice   = Invoice.create!(customer_id: parker.id, merchant_id: amazon.id, status: 'shipped', coupon_id: coupon.id ) 
    InvoiceItem.create!(item_id: brush.id, invoice_id: invoice.id)
    InvoiceItem.create!(item_id: comb.id, invoice_id: invoice.id)
    
    get "/api/v1/merchants/#{amazon.id}/invoices"

    expect(response).to be_successful
    expect(response.status).to eq(200)
    
    invoices = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(invoices).to be_an(Array)
    
    invoices.each do |invoice|
      expect(invoice[:id]).to be_an(String)
      expect(invoice[:type]).to eq('invoice')
      
      attrs = invoice[:attributes]

      expect(attrs[:customer_id]).to be_an(Integer)
      expect(attrs[:coupon_id]).to be_an(Integer)
      expect(attrs[:merchant_id]).to be_an(Integer)
      expect(attrs[:status]).to be_an(String)
    end
  end
end