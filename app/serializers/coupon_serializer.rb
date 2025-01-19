class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :unique_code, :percent_off, :dollar_off, :active

  attribute :status_message do |coupon|
    used_count = Invoice.where(coupon_id: coupon.id).count

    if used_count > 5
      coupon.update!(active: false) unless coupon.active?
      render json: {
        error: "#{coupon.name} cannot be used because the count is above 5"
      }, status: :unprocessable_entity
    end
  end
end