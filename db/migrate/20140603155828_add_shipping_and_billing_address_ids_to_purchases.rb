class AddShippingAndBillingAddressIdsToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :shipping_address_id, :integer
    add_column :purchases, :billing_address_id, :integer
  end
end
