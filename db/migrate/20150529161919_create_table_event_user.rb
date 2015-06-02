class CreateTableEventUser < ActiveRecord::Migration
  def change
    create_table :events_users, id: false do |t|
      t.belongs_to :event, index: true
      t.belongs_to :user, index: true
    end
  end

  def down
    drop_table :events_users
  end
end
