class Track

  attr_accessor :name, :description, :tags, :waypoints

  #WAYPOINTS = {type: "Feature", geometry: { type: "Point", coordinates: [125.6, 10.1] }, properties: { name: "Dinagat Islands" } }

  def initialize(params = nil)
    if params
      @name = params["name"]
      @description = params["description"]
      @waypoints = params["waypoints"]
      #@waypoints = WAYPOINTS
      @tags = params["keywords"]
    end
  end

end
