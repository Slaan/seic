class Track < ActiveRecord::Base

  attr_accessor :name, :description, :tags, :waypoints
  serialize :tags, Array

  def self.build_from_hash(params = nil)
    track = new
    if params
      track.name = params["name"]
      track.description = params["description"]
      track.waypoints = params["waypoints"]
      track.tags = params["keywords"]
    end
    track
  end

end
