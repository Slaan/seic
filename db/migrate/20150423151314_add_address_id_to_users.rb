class AddAddressIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address_id, :integer
    add_index :users, :address_id
  end
end
