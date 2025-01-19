class CouponSerializer
  include JSONAPI::Serializer
    set_type :coupon
    attributes :id, :name, :unique_code, :percent_off, :dollar_off, :merchant_id
end