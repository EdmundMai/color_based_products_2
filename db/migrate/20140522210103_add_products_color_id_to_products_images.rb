class AddProductsColorIdToProductsImages < ActiveRecord::Migration
  def change
    add_column :product_images, :products_color_id, :integer
  end
end
