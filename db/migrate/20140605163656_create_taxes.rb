class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.integer :state_id
      t.string :zip_code
      t.decimal :rate, precision: 8, scale: 5

      t.timestamps
    end
  end
end
