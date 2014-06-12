class RemoveItemIdentifierAndAddVariantIdToCartItems < ActiveRecord::Migration
  def change
    rename_column :cart_items, :item_identifier, :variant_id
  end
end
