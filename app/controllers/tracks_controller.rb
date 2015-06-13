class TracksController < ApplicationController

  CONNECTOR = ConnectorFactory.connection

  def index
    @tracks = JSON.generate(CONNECTOR.connection(current_user).get_tracks_of(user: current_user).body)
  end

  def show
  end

  def new
    @track = Track.new
  end
  
  def create
    data = params[:data]
    @track = Track.new(JSON.parse(data))
    CONNECTOR.connection(user: current_user).create_track(@track)
  end

  def delete
  end

  def update
  end

  def edit
  end

end
