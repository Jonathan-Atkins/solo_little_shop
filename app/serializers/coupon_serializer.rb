class CouponSerializer
  include JSONAPI::Serializer
    attributes :id, :name, :unique_code, :percent_off, :dollar_off, :merchant_id
end