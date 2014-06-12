class RemoveColorFromVariants < ActiveRecord::Migration
  def change
    remove_column :variants, :color
  end
end
