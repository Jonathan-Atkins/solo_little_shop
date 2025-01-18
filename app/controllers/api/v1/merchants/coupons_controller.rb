class Api::V1::Merchants::CouponsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    merchant = Merchant.find(params[:merchant_id]) # Raises RecordNotFound if merchant doesn't exist
    coupons = merchant.coupons # Fetches coupons associated with the merchant
    render json: CouponSerializer.new(coupons)
  end

  private

  def not_found(exception)
    render json: ErrorSerializer.new(exception, "404").format_error, status: :not_found
  end
end