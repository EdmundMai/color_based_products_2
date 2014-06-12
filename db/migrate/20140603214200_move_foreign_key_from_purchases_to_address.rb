class MoveForeignKeyFromPurchasesToAddress < ActiveRecord::Migration
  def change
    remove_column :purchases, :shipping_address_id
    remove_column :purchases, :billing_address_id
    add_column :addresses, :shipped_purchase_id, :integer
    add_column :addresses, :billed_purchase_id, :integer
  end
end
