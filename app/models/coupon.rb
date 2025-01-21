class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  validates :name, uniqueness: true, presence: true
  validates :unique_code, uniqueness: { scope: :merchant_id, message: "should be unique per merchant" }, presence: true
  validate  :must_have_discount, :used_count


  def self.active
    where(active: true)
  end

  def self.inactive
    where(active: false)
  end
  
  def check_and_update_status
    if self.used_count > 5
      self.active = false  
      save!  
    end
  end

  private

  def must_have_discount
    if percent_off.blank? && dollar_off.blank?
      errors.add(:percent_off, "can't be blank")  
      errors.add(:dollar_off, "can't be blank")   
    end
  end
end