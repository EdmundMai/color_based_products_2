class SplitDescriptionIntoLongAndShortDescriptionForProducts < ActiveRecord::Migration
  def change
    remove_column :products, :description
    add_column :products, :short_description, :text
    add_column :products, :long_description, :text
  end
end
