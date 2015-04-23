class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :details, :string
  end
end
