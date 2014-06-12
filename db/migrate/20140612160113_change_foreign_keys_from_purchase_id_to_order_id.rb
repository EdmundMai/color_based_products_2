class ChangeForeignKeysFromPurchaseIdToOrderId < ActiveRecord::Migration
  def change
    rename_column :addresses, :purchase_id, :order_id
    rename_column :line_items, :purchase_id, :order_id
  end
end
