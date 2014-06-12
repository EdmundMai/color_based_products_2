class ChangeSizeToSizeIdForVariants < ActiveRecord::Migration
  def change
    remove_column :variants, :size
    add_column :variants, :size_id, :integer
  end
end
