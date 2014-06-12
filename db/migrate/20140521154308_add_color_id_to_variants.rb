class AddColorIdToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :color_id, :integer
  end
end
