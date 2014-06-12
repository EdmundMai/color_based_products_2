class RemoveColorIdFromProductImages < ActiveRecord::Migration
  def change
    remove_column :product_images, :color_id
  end
end
