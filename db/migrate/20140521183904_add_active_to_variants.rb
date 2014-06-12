class AddActiveToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :active, :boolean
  end
end
