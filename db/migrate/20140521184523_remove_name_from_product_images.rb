class RemoveNameFromProductImages < ActiveRecord::Migration
  def change
    remove_column :product_images, :name
  end
end
