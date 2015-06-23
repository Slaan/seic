class TracksDeserializerMark

  def self.deserialize(track)
    Track.build_from_hash("name" => track["track_name"],
              "description" => track["track_description"],
              "keywords" => track["track_keywords"],
              "waypoints" => track["track_geojson"])
  end

  def self.deserialize_all(tracks)
    tracks.reduce([]) do |accu, track|
      accu << self.deserialize(track)
    end
  end

end
