class RemoveProductIdFromVariantsAndProductImages < ActiveRecord::Migration
  def change
    remove_column :variants, :product_id
    remove_column :product_images, :product_id
  end
end
