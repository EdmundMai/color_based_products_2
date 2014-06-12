class ChangePurchasesTableNameToOrders < ActiveRecord::Migration
  def change
    rename_table :purchases, :orders
  end
end
