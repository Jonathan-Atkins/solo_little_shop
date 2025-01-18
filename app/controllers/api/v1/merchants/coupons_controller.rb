class Api::V1::Merchants::CouponsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    coupons = Coupon.where(merchant_id: params[:merchant_id])
    render json: CouponSerializer.new(coupons)
  end

  private

  def not_found(exception)
    render json: ErrorSerializer.new(exception, "404").format_error, status: :not_found
  end
end