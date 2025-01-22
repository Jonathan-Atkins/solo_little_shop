require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should have_many :invoice_items }
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should belong_to(:coupon).optional }
  end

  describe "instance methods" do
    describe "#apply_coupon" do
      before :each do
        @merchant = Merchant.create!(name: "Merchant One")
        @customer = Customer.create!(first_name: "John", last_name: "Doe")
        @invoice = Invoice.create!(merchant: @merchant, customer: @customer)

        @coupon = Coupon.create!(
          name: "10% Off",
          unique_code: "TENOFF",
          percent_off: 0.1,
          used_count: 0,
          active: true,
          merchant: @merchant
        )
      end

      it "assigns a coupon to the invoice and increments the used_count" do
        result = @invoice.apply_coupon(@coupon)

        expect(result[:success]).to be(true)
        expect(@invoice.coupon).to eq(@coupon)
        expect(@coupon.used_count).to eq(1)
      end

      it "returns an error if the coupon is no longer active" do
        @coupon.update!(used_count: 5, active: false)

        result = @invoice.apply_coupon(@coupon)

        expect(result[:success]).to be(false)
        expect(result[:error]).to eq("10% Off cannot exceed 5. It has been used #{@coupon.used_count}")
        expect(@invoice.coupon).to be_nil
      end

      it "calls coupon's check_and_update_status method" do
        allow(@coupon).to receive(:check_and_update_status)

        @invoice.apply_coupon(@coupon)

        expect(@coupon).to have_received(:check_and_update_status)
      end

      it "does not save the coupon if it exceeds the usage limit" do
        @coupon.update!(used_count: 5, active: false)

        expect {
          @invoice.apply_coupon(@coupon)
        }.not_to change { @invoice.reload.coupon }
      end

      it "saves the coupon if valid and updates the used_count" do
        result = @invoice.apply_coupon(@coupon)

        expect(result[:success]).to be(true)
        expect(@invoice.reload.coupon).to eq(@coupon)
        expect(@coupon.reload.used_count).to eq(1)
      end
    end
  end
end