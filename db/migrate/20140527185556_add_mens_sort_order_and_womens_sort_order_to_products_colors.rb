class AddMensSortOrderAndWomensSortOrderToProductsColors < ActiveRecord::Migration
  def change
    add_column :products_colors, :mens_sort_order, :integer
    add_column :products_colors, :womens_sort_order, :integer
  end
end
