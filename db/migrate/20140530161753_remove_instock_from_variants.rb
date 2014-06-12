class RemoveInstockFromVariants < ActiveRecord::Migration
  def change
    add_column :variants, :in_stock, :boolean
  end
end
