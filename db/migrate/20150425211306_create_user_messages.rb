class CreateUserMessages < ActiveRecord::Migration
  def change
    create_table :user_messages do |t|
      t.integer :reciever_id
      t.integer :sender_id
      t.string :message
      t.string :picture

      t.timestamps null: false
    end
    add_index :user_messages, :reciever_id
    add_index :user_messages, :sender_id
  end
end
