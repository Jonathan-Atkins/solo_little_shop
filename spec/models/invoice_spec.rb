require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should have_many :invoice_items }
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should belong_to(:coupon).optional }
  end
end