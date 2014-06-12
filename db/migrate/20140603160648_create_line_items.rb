class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :purchase_id
      t.integer :quantity
      t.integer :variant_id
      t.money :unit_price

      t.timestamps
    end
  end
end
