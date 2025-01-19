class Api::V1::Coupons::CouponsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def show
    coupon = Coupon.find(params[:id])
    used_count = Invoice.where(coupon_id: coupon.id).count

    if used_count > 5
      coupon.update!(active: false) unless coupon.active?
    end

    render json: { coupon: CouponSerializer.new(coupon), used_count: used_count }
  end

  private

  def not_found(exception)
    render json: ErrorSerializer.new(exception, "404").format_error, status: :not_found
  end
end