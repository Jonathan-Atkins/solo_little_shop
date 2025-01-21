class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name, :coupons_count, :invoice_coupon_count
  attributes :item_count, if: Proc.new { |merchant, params|
    params[:count] == "true"
  }
end