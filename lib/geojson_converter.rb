class GeojsonConverter

  ENTITY_FACTORY = ::RGeo::GeoJSON::EntityFactory.instance
  GEO_FACTORY = ::RGeo::Cartesian.simple_factory

  
  def self.to_geojson(geo_data)
    points = geo_data.reduce([]) do |accu, point|
      accu << ENTITY_FACTORY.feature(GEO_FACTORY.point(point["latitude"], point["longitude"]))
    end
    feature = ENTITY_FACTORY.feature_collection(points)
    RGeo::GeoJSON.encode(feature).to_json
  end
end
