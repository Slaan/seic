class TracksController < ApplicationController

  CONNECTOR = ConnectorFactory.connection
  
  def show
  end

  def new
    @track = Track.new
  end
  
  def create
    p params
    # @track = Track.new
    # @track.name = params[:name]
    # @track.description = params[:description]
    # @track.waypoints = params[:waypoints]
    # @track.tags = params[:tags]
    # CONNECTOR.connection(current_user).create_track(@track)
  end

  def delete
    
  end

  def update
  end

  def edit
  end
end
