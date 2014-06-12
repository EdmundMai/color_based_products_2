class RemoveMenWomenFromVariants < ActiveRecord::Migration
  def change
    remove_column :variants, :men
    remove_column :variants, :women
  end
end
