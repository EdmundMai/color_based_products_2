class AddSortOrderToProductImages < ActiveRecord::Migration
  def change
    add_column :product_images, :sort_order, :integer
  end
end
