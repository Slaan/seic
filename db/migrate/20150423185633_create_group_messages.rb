class CreateGroupMessages < ActiveRecord::Migration
  def change
    create_table :group_messages do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :message
      
      t.timestamps null: false
    end
    add_index :group_messages, :user_id
    add_index :group_messages, :group_id
  end
end
