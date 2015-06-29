class DualConnector

  attr_reader :response

  ERROR_DOWN = "We're experiencing connectivity issues with our backend, so %{function} was temporarily disabled.<br/> Please try again in a few minutes.".html_safe

  def initialize
    @connector_mark = ConnectorMark.new
    @connector_team6 = ConnectorTeam6.new
  end


  def connection(params)
    @connector_mark = @connector_mark.connection(params)
    self
  end

  def create_user(user)
    @response = @connector_mark.create_user(user)
    if @response
      return true if @response.status == 201
      user.errors_backend << { text: (ERROR_DOWN % { function: "registration" }).html_safe } if @response.status == 404
      false
    else
      user.errors_backend << { text: (ERROR_DOWN % { function: "registration" }).html_safe }
      false
    end
  end

  def update_user(username, old_user, new_user)
    @response = @connector_mark.update_user(username, old_user, new_user)
    if @response
      return true if @response.status == 200
      user.errors_backend << { text: (ERROR_DOWN % { function: "updating users" }).html_safe } if @response.status == 404
      false
    else
      user.errors_backend << { text: (ERROR_DOWN % { function: "updating users" }).html_safe }
      false
    end
  end

  def get_all_tracks
    tracks_mark_response = @connector_mark.get_all_tracks
    tracks_mark = TracksDeserializerMark.deserialize_all(tracks_mark_response.body) if tracks_mark_response and tracks_mark_response.status == 200
    tracks_team6_response = @connector_team6.get_all_tracks
    tracks_team6 = TracksDeserializerTeam6.deserialize_all(tracks_team6_response.body) if tracks_team6_response and tracks_team6_response.status == 200
    (tracks_mark or []) + (tracks_team6 or []) + Track.all
  end

  def get_track(name)
    track_from_db = Track.find_by(name: name)
    return track_from_db if track_from_db
    track_from_mark = @connector_mark.get_track(name)
    return TracksDeserializerMark.deserialize(track_from_mark.body) if track_from_mark and (track_from_mark.status == 200)
    nil
  end

  def get_tracks_of(user)
    tracks_from_mark = @connector_mark.get_tracks_of(user)
    tracks_from_mark = nil unless (tracks_from_mark and (tracks_from_mark.status == 200))
    tracks_from_mark = TracksDeserializerMark.deserialize_all(tracks_from_mark.body) if tracks_from_mark
    tracks_from_db = Track.all
    (tracks_from_mark or []) + tracks_from_db
  end

  def create_track(track, current_user)
    response = @connector_mark.create_track(track)
    unless response and response.status == 201
      track.user = current_user
      track.save
    end
    track
  end

  #temp position, plx move me
  def move_tracks_to_backend
    while track = Track.first
      index = 1
      loop do
        @response = @connector_mark.connection(user: track.user)
                   .create_track(track)
        track.name = track.name + index.to_s
        index += 1
        break unless @response && name_conflict(@response)
      end
      if @response && (@response.status == 201)
        track.delete
      else
        break
      end
    end
  end

  def mark_up?
    @connector_mark.up?
  end

  def team6_up?
    @connector_team6.up?
  end

  private

  def name_conflict(response)
    response.status == 409
  end
end
