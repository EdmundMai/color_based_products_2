class AddStateIdAndCityToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :state_id, :integer
    add_column :addresses, :city, :string
  end
end
