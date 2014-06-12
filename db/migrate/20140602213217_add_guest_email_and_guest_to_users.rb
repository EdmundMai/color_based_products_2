class AddGuestEmailAndGuestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :guest, :boolean
    add_column :users, :guest_email, :string
  end
end
