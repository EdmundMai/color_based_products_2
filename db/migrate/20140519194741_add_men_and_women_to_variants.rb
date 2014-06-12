class AddMenAndWomenToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :men, :boolean
    add_column :variants, :women, :boolean
  end
end
