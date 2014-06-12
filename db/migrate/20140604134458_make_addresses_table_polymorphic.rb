class MakeAddressesTablePolymorphic < ActiveRecord::Migration
  def change
    remove_column :addresses, :billed_purchase_id
    remove_column :addresses, :shipped_purchase_id
    add_column :addresses, :addressable_type, :string
    add_column :addresses, :addressable_id, :integer
    add_index :addresses, [:addressable_type, :addressable_id]
  end
end
