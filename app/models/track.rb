class Track < ActiveRecord::Base
  serialize :tags, Array
  belongs_to :user

  def self.build_from_hash(params = nil)
    p params
    track = new
    if params
      track.name = params["name"]
      track.description = params["description"]
      track.waypoints = params["waypoints"]
      track.tags = params["keywords"]
    end
    track
  end

  def to_hash
    {track_name: name,
      track_description: description,
      track_keywords: tags,
      track_geojson: waypoints }
  end
end
