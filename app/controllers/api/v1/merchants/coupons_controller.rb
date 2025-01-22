class Api::V1::Merchants::CouponsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = merchant.coupons
  
    if coupons.empty?
      render json: { message: "#{merchant.name} has no coupons" }, status: :ok
    elsif params[:active] == "true" 
      render json: CouponSerializer.new(coupons.active), status: :ok
    elsif params[:active] == "false" 
      render json: CouponSerializer.new(coupons.inactive), status: :ok
    else
      render json: CouponSerializer.new(coupons), status: :ok
    end
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.create!(coupon_params)
    render json: CouponSerializer.new(coupon), status: :ok
  end

  def update
    merchant = Merchant.find(params[:merchant_id]) 
    coupon = Coupon.find(params[:id])
    coupon.active = !coupon.active
    coupon.save!
    
    status_message = coupon.active ? "active" : "inactive"
    render json: { message: "#{coupon.name} is now #{status_message}", active: coupon.active }, status: :ok
  end

  private

  def coupon_params
    params.permit(:name, :unique_code, :percent_off, :dollar_off, :active)
  end

  def not_found(exception)
    render json: ErrorSerializer.new(exception, "404").format_error, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { message: "unprocessable entity", errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end