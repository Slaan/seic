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
    data = params[:data]
    p JSON.parse(data)
    @track = Track.build_from_hash(JSON.parse(data))
    p @track
    p @track.to_hash
    CONNECTOR.connection(user: current_user).create_track(@track, current_user)
  end

  def delete
  end

  def update
  end

  def edit
  end

  def move_to_backend
    CONNECTOR.move_tracks_to_backend
    redirect_to tracks_path
  end

  def get
    id = params[:id]
    p id

    @track = CONNECTOR.connection(user: current_user).get_track(id)
    puts "@track"
    p @track

    respond_to do |format|
      format.json { render :json => @track }
    end

  end
end
