class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.datetime :order_date
      t.money :total
      t.money :shipping
      t.money :tax
      t.money :subtotal

      t.timestamps
    end
  end
end
