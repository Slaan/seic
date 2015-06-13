class TracksDeserializerTeam6

  def self.deserialize(track)
    Track.new("name" => track["label"],
      "description" => "",
      "keywords" => track["tags"],
      "waypoints" => GeojsonConverter.to_geojson(track["streckenpunkte"]))
  end

  def self.deserialize_all(tracks)
    tracks.reduce([]) do |accu, track|
      accu << self.deserialize(track)
    end
  end
end
