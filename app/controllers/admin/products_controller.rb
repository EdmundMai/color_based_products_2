class Admin::ProductsController < Admin::BaseController
  
  def index
    @products = Product.all
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      redirect_to edit_admin_product_path(@product), notice: "Your product was successfully updated."
    else
      render 'edit'
    end
  end
  
  def new
    @product = Product.new
    @product.variants.build
  end
  
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to edit_admin_product_path(@product), notice: "Your product was successfully created."
    else
      render 'new'
    end
  end
  
  def generate_variants
    price = params[:price] || 0
    sizes_and_measurements = params[:sizes_and_measurements]
    sizes_and_weights = params[:sizes_and_weights]
    colors_and_genders = params[:colors_and_genders]
    @products_colors = []
    colors_and_genders.each do |color_id, gender|
      product_color = ProductsColor.new(color_id: color_id,
                                        mens: gender.include?("men"),
                                        womens: gender.include?("women")
                                        )
      sizes_and_measurements.each do |size_id, measurements|
        product_color.variants << Variant.new(size_id: size_id,
                                          measurements: measurements,
                                          weight: sizes_and_weights[size_id],
                                          price: price)
      end
      @products_colors << product_color
    end

    respond_to do |format|
      format.js
    end
  end
  
  def add_size
    respond_to do |format|
      format.js
    end
  end
  
  def add_color
    respond_to do |format|
      format.js
    end
  end
  
  
  def add_variant
    @product = Product.find(params[:product_id])
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def product_params
      params.require(:product).permit(:name, 
                                      :short_description, 
                                      :long_description, 
                                      :active, 
                                      :meta_description, 
                                      :page_title,
                                      :taxable, 
                                      :vendor_id, 
                                      :material_id, 
                                      :shape_id,
                                      :category_id, 
                                      :products_colors_attributes => [
                                        :id, 
                                        :mens, 
                                        :womens,
                                        :color_id,
                                        :_destroy, 
                                        :product_images_attributes => [
                                          :color_id, 
                                          :image => []
                                        ],
                                        :variants_attributes => [
                                          :id,
                                          :weight,
                                          :measurements,
                                          :sku,
                                          :price,
                                          :in_stock,
                                          :products_color_id,
                                          :size_id
                                        ]                                        
                                      ]
                                      )
    end
    
end