class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many   :invoices
   validates :name, uniqueness: true, presence: true
   validates :unique_code, uniqueness: { scope: :merchant_id, message: "should be unique per merchant" }, presence: true
   validates :percent_off, presence: true, unless: -> {dollar_off.present?}
   validates :dollar_off, presence: true, unless: -> {percent_off.present?}
end