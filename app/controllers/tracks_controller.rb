class TracksController < ApplicationController

  CONNECTOR = ConnectorFactory.connection


  def index
    @tracks = CONNECTOR.connection(current_user).get_all_tracks
  end
  
  def show
  end

  def new
    @track = Track.new
  end
  
  def create
    
    data = params[:data]
    @track = Track.new(JSON.parse(data))
    CONNECTOR.connection(current_user).create_track(@track)
  end

  def delete
    
  end

  def update
  end

  def edit
  end
end
