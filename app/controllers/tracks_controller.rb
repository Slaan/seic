class TracksController < ApplicationController
  CONNECTOR = ConnectorFactory.connection

  def index
<<<<<<< HEAD

    @tracks = TracksDeserializerMark.deserialize_all(CONNECTOR.connection(user: current_user).get_tracks_of(current_user).body)

    #@tracks = JSON.generate(CONNECTOR.connection(user: current_user).get_tracks_of(current_user).body)

=======
    @tracks = CONNECTOR.connection(user: current_user).get_tracks_of(current_user)
>>>>>>> 184974e0449ca5a050addb821f7188b608a8c3aa
  end

  def show
  end

  def new
    @track = Track.new
  end

  def create
    data = params[:data]
    @track = Track.build_from_hash(JSON.parse(data))
    CONNECTOR.connection(user: current_user).create_track(@track, current_user)
  end

  def delete
  end

  def update
  end

  def edit
  end

<<<<<<< HEAD
=======
  def move_to_backend
    CONNECTOR.move_tracks_to_backend
    redirect_to tracks_path
  end

>>>>>>> 184974e0449ca5a050addb821f7188b608a8c3aa
  def get
    id = params[:id]
    p id

<<<<<<< HEAD
    @track = TracksDeserializerMark.deserialize(CONNECTOR.connection(user: current_user).get_track(id).body)
=======
    @track = CONNECTOR.connection(user: current_user).get_track(id)
>>>>>>> 184974e0449ca5a050addb821f7188b608a8c3aa
    puts "@track"
    p @track

    respond_to do |format|
      format.json { render :json => @track }
    end

  end
end
