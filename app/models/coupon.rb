class Coupon < ApplicationRecord
  belongs_to :merchant
  validates  :name, :unique_code, uniqueness: true
  validates  :name, presence: true
  validates  :unique_code, uniqueness: { scope: :merchant_id, message: "should be unique per merchant" }
  validates  :percent_off, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
end