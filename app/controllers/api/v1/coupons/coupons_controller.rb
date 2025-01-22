class Api::V1::Coupons::CouponsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def show
    coupon = Coupon.find(params[:id])
    coupon.check_and_update_status  
  
    render json: CouponSerializer.new(coupon), status: :ok
  end

  private

  def not_found(exception)
    render json: ErrorSerializer.new(exception, "404").format_error, status: :not_found
  end
end