class AddFeaturedMensAndWomensColorIdsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :featured_mens_color_id, :integer
    add_column :products, :featured_womens_color_id, :integer
  end
end
