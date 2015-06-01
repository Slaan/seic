class TracksDeserializerMark

  def self.deserialize(track)
    Track.new(name: track["track_name"],
      description: track["track_description"],
      keywords: track["track_keywords"],
      waypoints: track["track_geojson"])
  end
end
