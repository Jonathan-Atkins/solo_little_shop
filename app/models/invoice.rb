class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  belongs_to :coupon, optional: true

  def apply_coupon(coupon)
    coupon.increment!(:used_count)
    coupon.reload
  
    coupon.check_and_update_status 
  
    if !coupon.active
      return { success: false, error: "#{coupon.name} cannot exceed 5. It has been used #{coupon.used_count}" }
    end
  
    self.coupon = coupon
    save
    { success: true }
  end  
end