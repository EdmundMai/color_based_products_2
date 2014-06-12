class AddColorIdToProductImages < ActiveRecord::Migration
  def change
    add_column :product_images, :color_id, :integer
  end
end
