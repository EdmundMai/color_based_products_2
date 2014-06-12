class CheckoutsController < ApplicationController
  
  before_filter :set_cache_headers, only: [:billing]
  
  def add_to_cart
    @cart = current_or_guest_user.cart
    @cart.add_item!(params[:variant_id], params[:quantity])
    respond_to do |format|
      format.html { redirect_to checkout_path }
    end
  end
  
  def show
  end
  
  def billing
    @order = current_or_guest_user.last_incomplete_order
    if current_user
      @payment_info = PaymentInfo.new(
                                  shipping_address_first_name: @order.shipping_address.try(:first_name),
                                  shipping_address_last_name: @order.shipping_address.try(:last_name),
                                  shipping_address_street_address: @order.shipping_address.try(:street_address),
                                  shipping_address_street_address2: @order.shipping_address.try(:street_address2),
                                  shipping_address_zip_code: @order.shipping_address.try(:zip_code),
                                  shipping_address_city: @order.shipping_address.try(:city),
                                  shipping_address_state_id: @order.shipping_address.try(:state_id),
                                  billing_address_first_name: @order.billing_address.try(:first_name),
                                  billing_address_last_name: @order.billing_address.try(:last_name),
                                  billing_address_street_address: @order.billing_address.try(:street_address),
                                  billing_address_street_address2: @order.billing_address.try(:street_address2),
                                  billing_address_zip_code: @order.billing_address.try(:zip_code),
                                  billing_address_city: @order.billing_address.try(:city),
                                  billing_address_state_id: @order.billing_address.try(:state_id),
                                  order_id: @order.id
                                  )
    else
      @payment_info = PaymentInfo.new(order_id: @order.id)
    end
  end
  
  def update_billing
    @order = current_or_guest_user.last_incomplete_order
    @payment_info = PaymentInfo.new(params[:payment_info].merge(order_id: @order.id))
    @payment_info.save
    respond_to do |format|
      format.js
    end
  end
  
  def submit_order
    @usaepay = UsaepayWrapper.new(params[:credit_card])
    if @usaepay.authorize
      order = current_or_guest_user.last_incomplete_order
      order.finalize_order!(current_or_guest_user.cart)
      delete_sensitive_session_variables!
      render js: "window.location = '#{review_checkout_path}'"
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def review
  end
  
  private
  
    def set_cache_headers
      response.headers["Cache-Control"] = "no-cache, no-store"
    end
  
    def delete_sensitive_session_variables!
      cookies.delete(:guest_user_id)
    end

  
end