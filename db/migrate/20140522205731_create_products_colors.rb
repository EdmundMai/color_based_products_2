class CreateProductsColors < ActiveRecord::Migration
  def change
    create_table :products_colors do |t|
      t.integer :color_id
      t.integer :product_id
      t.boolean :mens
      t.boolean :womens

      t.timestamps
    end
  end
end
