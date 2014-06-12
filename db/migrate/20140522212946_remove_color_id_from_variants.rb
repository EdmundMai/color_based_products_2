class RemoveColorIdFromVariants < ActiveRecord::Migration
  def change
    remove_column :variants, :color_id
  end
end
