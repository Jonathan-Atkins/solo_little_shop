class CouponSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :unique_code, :percent_off, :dollar_off, :active, :used_count

  attribute :used_count do |coupon|
    coupon.invoices.count
  end
end