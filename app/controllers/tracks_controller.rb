class TracksController < ApplicationController

  
  
  def show
  end

  def new
    @track = Track.new
  end
  
  def create
    @track = Track.new
    @track.name = params[:name]
    @track.description = params[:description]
    @track.waypoints = params[:waypoints]
    @track.tags = params[:tags]
  end

  def delete
    
  end

  def update
  end

  def edit
  end
end
