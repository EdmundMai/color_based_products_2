class AddTaxableToProducts < ActiveRecord::Migration
  def change
    add_column :products, :taxable, :boolean
  end
end
