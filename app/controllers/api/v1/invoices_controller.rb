class Api::V1::InvoicesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :merchant_not_found_error_response

  def index
    merchant = Merchant.find(params[:merchant_id])
    invoices = merchant.invoices

    if params[:status]
      invoice_status = invoices.select { |invoice| invoice.status == params[:status] }
      render json: InvoiceSerializer.new(invoice_status)
    else
      render json: InvoiceSerializer.new(invoices)
    end
  end

  def create
    invoice = Invoice.new(invoice_params)

    if invoice.save
      if invoice.coupon_id
        coupon = Coupon.find(invoice.coupon_id)
        coupon.increment!(:used_count)
      end

      render json: InvoiceSerializer.new(invoice), status: :created
    else
      render json: { error: invoice.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def add_coupon
    invoice = Invoice.find(params[:id])
    coupon = Coupon.find(params[:coupon_id])

    result = invoice.apply_coupon(coupon)

    if result[:success]
      render json: InvoiceSerializer.new(invoice), status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:customer_id, :merchant_id, :coupon_id, :status)
  end

  def merchant_not_found_error_response(error)
    render json: { error: "Merchant not found", message: error.message }, status: :not_found
  end
end