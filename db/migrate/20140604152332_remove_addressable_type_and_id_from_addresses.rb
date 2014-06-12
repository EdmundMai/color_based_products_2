class RemoveAddressableTypeAndIdFromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :addressable_type
    remove_column :addresses, :addressable_id
    add_column :addresses, :type, :string
  end
end
