class Admin::ProductImagesController < Admin::BaseController
  
  def destroy
    @product_image = ProductImage.find(params[:id])
    @product_image.destroy
    respond_to do |format|
      format.js
      format.html { render nothing: true }
    end
  end
  
  def update_sort_order
    return unless params[:new_order].present?
    params[:new_order].each_with_index do |product_image_id, index|
      product_image = ProductImage.find(product_image_id)
      product_image.sort_order = index
      product_image.save
    end
    respond_to do |format|
      format.js { render json: '' }
    end
  end
  
end