class ChangeVariantPriceToAllowNil < ActiveRecord::Migration
  def change
    remove_money :variants, :price
    add_money :variants, :price, amount: { null: true }
  end
end
