class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.integer :product_id
      t.decimal :weight, :precision => 30, :scale => 2
      t.string :measurements
      t.string :size
      t.string :color
      t.decimal :price, :precision => 30, :scale => 2

      t.timestamps
    end
  end
end
