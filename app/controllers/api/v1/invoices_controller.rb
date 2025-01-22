class Api::V1::InvoicesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error_response

  def index
    begin
      merchant = Merchant.find(params[:merchant_id])
      invoices = merchant.invoices

      if params[:status].present?
        invoices = invoices.where(status: params[:status])
      end

      render json: InvoiceSerializer.new(invoices)
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "Merchant not found", message: e.message }, status: :not_found
    end
  end

  def create
    invoice = Invoice.new(invoice_params)

    if invoice.save
      if invoice.coupon_id
        coupon = Coupon.find(invoice.coupon_id)
        coupon.increment!(:used_count)
      end

      render json: InvoiceSerializer.new(invoice), status: :ok
    else
      render json: { error: invoice.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def add_coupon
    begin
      invoice = Invoice.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      return render json: { error: "Invoice not found", message: e.message }, status: :not_found
    end

    coupon = Coupon.find_by(id: params[:coupon_id])

    if coupon.nil?
      render json: { error: "Coupon not found" }, status: :unprocessable_entity
    elsif invoice.apply_coupon(coupon)[:success]
      render json: InvoiceSerializer.new(invoice), status: :ok
    else
      render json: { error: "Unable to apply coupon" }, status: :unprocessable_entity
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:customer_id, :merchant_id, :coupon_id, :status)
  end

  def record_not_found_error_response(error)
    render json: { error: "Record not found", message: error.message }, status: :not_found
  end
end