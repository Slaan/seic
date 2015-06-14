class TracksController < ApplicationController

  CONNECTOR = ConnectorFactory.connection

  def index
    @tracks = JSON.generate(CONNECTOR.connection(user: current_user).get_tracks_of(current_user).body)
  end

  def show
  end

  def new
    @track = Track.new
  end
  
  def create
    data = params[:data]
    @track = Track.build_from_hash(JSON.parse(data))
    CONNECTOR.connection(user: current_user).create_track(@track)
  end

  def delete
  end

  def update
  end

  def edit
  end

end
