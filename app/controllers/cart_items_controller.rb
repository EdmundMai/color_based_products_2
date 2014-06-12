class CartItemsController < ApplicationController
  
  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to checkout_path
    # respond_to do |format|
    #   format.js
    # end
  end
  
end