class UpdateVariantsToUseMoneyGem < ActiveRecord::Migration
  def change
    remove_column :variants, :price
    add_money :variants, :price
  end
end
