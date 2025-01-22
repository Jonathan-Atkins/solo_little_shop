require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "relationships" do
    it { should have_many :invoices }
  end

  describe "class methods" do
    before :each do
      @merchant1 = Merchant.create!(name: "Merchant One")
      @merchant2 = Merchant.create!(name: "Merchant Two")

      @customer1 = Customer.create!(first_name: "John", last_name: "Doe")
      @customer2 = Customer.create!(first_name: "Jane", last_name: "Smith")
      @customer3 = Customer.create!(first_name: "Alice", last_name: "Johnson")

      Invoice.create!(merchant: @merchant1, customer: @customer1)
      Invoice.create!(merchant: @merchant1, customer: @customer2)
      Invoice.create!(merchant: @merchant2, customer: @customer3)
    end

    describe ".customers_by_merchant" do
      it "returns unique customers for a given merchant" do
        result = Customer.customers_by_merchant(@merchant1.id)

        expect(result).to contain_exactly(@customer1, @customer2)
        expect(result).not_to include(@customer3)
      end
    end
  end
end