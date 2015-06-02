class AddTrackToEvents < ActiveRecord::Migration
  def change
    add_column :events, :track, :string
  end
end
