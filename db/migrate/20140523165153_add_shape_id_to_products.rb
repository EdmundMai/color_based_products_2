class AddShapeIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :shape_id, :integer
  end
end
