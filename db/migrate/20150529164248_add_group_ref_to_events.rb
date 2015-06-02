class AddGroupRefToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :group, index: true, foreign_key: true
  end
end