class Api::V1::Merchants::CouponsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = merchant.coupons
    render json: CouponSerializer.new(coupons)
  end

  def create
    begin
      merchant = Merchant.find(params[:merchant_id]) 
      coupon = merchant.coupons.create!(coupon_params) 
      render json: CouponSerializer.new(coupon), status: :ok
    rescue ActiveRecord::RecordInvalid => error_message
      render json: { message: "unprocessable entity", errors: error_message.record.errors.full_messages }, status: 422
    end
  end

  def update
    coupon = Coupon.find(params[:id])

    if coupon.active
      coupon.active = false
      coupon.save!
      render json: { message: "#{coupon.name} is now inactive" }, status: :ok
    else
      coupon.active = true
      coupon.save!
      render json: { message: "#{coupon.name} is now active" }, status: :ok
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :unique_code, :percent_off, :dollar_off, :active) 
  end

  def not_found(exception)
    render json: ErrorSerializer.new(exception, "404").format_error, status: :not_found
  end
end