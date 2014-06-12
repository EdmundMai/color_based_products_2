class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :street_address
      t.string :street_address2
      t.string :zip_code
      t.string :phone_number

      t.timestamps
    end
  end
end
