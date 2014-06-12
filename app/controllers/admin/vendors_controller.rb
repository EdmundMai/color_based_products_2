class Admin::VendorsController < Admin::BaseController
  def create
    @vendor = Vendor.where(name: vendor_params[:name]).first_or_create
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def vendor_params
    params.require(:vendor).permit(:name)
  end
  
end