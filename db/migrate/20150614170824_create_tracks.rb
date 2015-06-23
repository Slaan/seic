class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :description
      t.string :waypoints
      t.string :tags, array: true, default: []
    end
  end
end
