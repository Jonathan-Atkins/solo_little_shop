require 'rails_helper'

RSpec.describe "Invoices API", type: :request do
  before(:each) do
    @test_merchant_1 = Merchant.create!(name: "Test Merchant 1")
    @test_merchant_2 = Merchant.create!(name: "Test Merchant 2")
    @test_customer = Customer.create!(first_name: 'Buddy', last_name: "De Elf")

    @test_invoice1 = Invoice.create!(customer_id: @test_customer.id, merchant_id: @test_merchant_1.id, status: "shipped")
    @test_invoice2 = Invoice.create!(customer_id: @test_customer.id, merchant_id: @test_merchant_1.id, status: "packaged")
    @test_invoice3 = Invoice.create!(customer_id: @test_customer.id, merchant_id: @test_merchant_1.id, status: "returned")
  end

  it 'can get all invoices' do
    get "/api/v1/merchants/#{@test_merchant_1.id}/invoices"
    
    expect(response.status).to eq(200)
    
    invoices = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(invoices.length).to eq(3)

    get "/api/v1/merchants/#{@test_merchant_2.id}/invoices"
    
    invoices = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response.status).to eq(200)
    expect(invoices.length).to eq(0)
  end

  it 'can return all invoices for a given status' do
    get "/api/v1/merchants/#{@test_merchant_1.id}/invoices?status=shipped"
    
    expect(response.status).to eq(200)

    invoices = JSON.parse(response.body, symbolize_names: true)
    
    expect(invoices[:data].length).to eq(1)

    get "/api/v1/merchants/#{@test_merchant_1.id}/invoices?status=packaged"
    
    expect(response.status).to eq(200)

    invoices = JSON.parse(response.body, symbolize_names: true)
    
    expect(invoices[:data].length).to eq(1)

    get "/api/v1/merchants/#{@test_merchant_1.id}/invoices?status=returned"
    
    expect(response.status).to eq(200)

    invoices = JSON.parse(response.body, symbolize_names: true)
    
    expect(invoices[:data].length).to eq(1)
  end

  it "can return 404 error when the invalid merchant number is passed in" do
    get "/api/v1/merchants/9999/invoices"
    
    expect(response).to have_http_status(404)
    
    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response[:error]).to eq("Merchant not found")
    expect(error_response[:message]).to eq("Couldn't find Merchant with 'id'=9999")  

    get "/api/v1/merchants/hello/invoices"
    
    expect(response).to have_http_status(404)
    
    error_response = JSON.parse(response.body, symbolize_names: true)
    expect(error_response[:error]).to eq("Merchant not found")
    expect(error_response[:message]).to eq("Couldn't find Merchant with 'id'=hello")
  end

  it "returns an error when creating an invoice with invalid attributes" do
    invalid_invoice_params = { customer_id: nil, merchant_id: @test_merchant_1.id, status: 'shipped' }

    post "/api/v1/merchants/#{@test_merchant_1.id}/invoices", params: { invoice: invalid_invoice_params }

    expect(response.status).to eq(422)

    error_response = JSON.parse(response.body, symbolize_names: true)
    expect(error_response[:error]).to eq("Customer must exist")
  end

  it "creates an invoice and applies the coupon if valid" do
    coupon = Coupon.create!(name: "10% Off", unique_code: "TENOFF", percent_off: 0.1, used_count: 0, active: true, merchant: @test_merchant_1)
    
    invoice_params = { customer_id: @test_customer.id, merchant_id: @test_merchant_1.id, coupon_id: coupon.id, status: 'shipped' }
    
    post "/api/v1/merchants/#{@test_merchant_1.id}/invoices", params: { invoice: invoice_params }

    expect(response.status).to eq(200)
    invoice = JSON.parse(response.body, symbolize_names: true)
    expect(invoice[:data][:attributes][:coupon_id]).to eq(coupon.id)
    expect(coupon.reload.used_count).to eq(1)
  end

  it 'returns an error when applying an invalid coupon' do
    invoice = @test_merchant_1.invoices.create!(customer_id: @test_customer.id, status: 'shipped')

    patch "/api/v1/merchants/#{@test_merchant_1.id}/invoices/#{invoice.id}/add_coupon", params: { coupon_id: 9999 }

    expect(response.status).to eq(422)

    error_response = JSON.parse(response.body, symbolize_names: true)
    expect(error_response[:error]).to eq("Coupon not found")
  end

  it 'returns an error when attempting to apply a coupon to a non-existent invoice' do
    patch "/api/v1/merchants/#{@test_merchant_1.id}/invoices/99999999/add_coupon", params: { coupon_id: 1 }

    expect(response.status).to eq(404)

    error_response = JSON.parse(response.body, symbolize_names: true)
    expect(error_response[:error]).to eq("Invoice not found")
  end

  it 'applies a valid coupon to the invoice and increments the coupon used_count' do
    coupon = Coupon.create!(name: "10% Off", unique_code: "TENOFF", percent_off: 0.1, used_count: 0, active: true, merchant: @test_merchant_1)
    
    invoice = @test_merchant_1.invoices.create!(customer_id: @test_customer.id, status: 'shipped')

    patch "/api/v1/merchants/#{@test_merchant_1.id}/invoices/#{invoice.id}/add_coupon", params: { coupon_id: coupon.id }

    expect(response.status).to eq(200)
    expect(invoice.reload.coupon).to eq(coupon)
    expect(coupon.reload.used_count).to eq(1)
  end

  it 'returns an error when trying to apply a coupon that has exceeded its usage limit' do
    coupon = Coupon.create!(name: "10% Off", unique_code: "TENOFF", percent_off: 0.1, used_count: 5, active: false, merchant: @test_merchant_1)
    
    invoice = @test_merchant_1.invoices.create!(customer_id: @test_customer.id, status: 'shipped')

    patch "/api/v1/merchants/#{@test_merchant_1.id}/invoices/#{invoice.id}/add_coupon", params: { coupon_id: coupon.id }

    expect(response.status).to eq(422)
    expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq("Unable to apply coupon")
  end
end