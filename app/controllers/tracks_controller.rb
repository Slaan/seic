class TracksController < ApplicationController


  CONNECTOR = ConnectorFactory.connection

  def index
    @tracks = CONNECTOR.connection(user: current_user).get_tracks_of(current_user)
  end

  def show
  end

  def new
    @track = Track.new
  end
  
  def create
    @track = Track.build_from_hash(JSON.parse(params[:data]))
    CONNECTOR.connection(user: current_user).create_track(@track, current_user)
  end

  def delete
  end

  def update
  end

  def edit
  end

end
