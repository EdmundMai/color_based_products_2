class AddProductsColorIdToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :products_color_id, :integer
  end
end
