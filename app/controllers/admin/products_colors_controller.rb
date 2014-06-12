class Admin::ProductsColorsController < Admin::BaseController
  def update_mens_sort_order
    return unless params[:new_order].present?
    params[:new_order].each_with_index do |product_color_id, index|
      product_image = ProductsColor.find(product_color_id)
      product_image.mens_sort_order = index
      product_image.save
    end
    respond_to do |format|
      format.js { render json: '' }
    end
  end
  
  def update_womens_sort_order
    return unless params[:new_order].present?
    params[:new_order].each_with_index do |product_color_id, index|
      product_image = ProductsColor.find(product_color_id)
      product_image.womens_sort_order = index
      product_image.save
    end
    respond_to do |format|
      format.js { render json: '' }
    end
  end
  
  def remove
    if params[:id].present?
      @products_color = ProductsColor.find(params[:id])
      @products_color.destroy
    end
    @index = params[:index]
    respond_to do |format|
      format.js
      format.html { render nothing: true }
    end
  end
end