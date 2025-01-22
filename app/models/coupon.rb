class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  validates :name, uniqueness: true, presence: true
  validates :unique_code, uniqueness: { scope: :merchant_id, message: "should be unique per merchant" }, presence: true
  validate  :must_have_discount, :used_count
  validate  :limit_coupons_to_five

  def self.active
    where(active: true)
  end

  def self.inactive
    where(active: false)
  end

  private

  def must_have_discount
    if percent_off.blank? && dollar_off.blank?
      errors.add(:percent_off, "can't be blank")
      errors.add(:dollar_off, "can't be blank")
    end
  end

  def limit_coupons_to_five
    if active? && merchant && merchant.coupons.where(active: true).count >= 5
      errors.add(:base, "Merchants can only have 5 active coupons at one time")  
    end
  end
end