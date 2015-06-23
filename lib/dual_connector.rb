class DualConnector

  def initialize
    @connector_mark = ConnectorMark.new
    @connector_team6 = ConnectorTeam6.new
    @mark_up = true
  end


  def connection(params)
    @connector_mark = @connector_mark.connection(params)
    self
  end

  def create_user(user)
    @connector_mark.create_user(user)
  end

  def update_user(username, old_user, new_user)
    @connector_mark.update_user(username, old_user, new_user)
  end

  def get_all_tracks
    tracks_mark_response = @connector_mark.get_all_tracks
    tracks_mark = TracksDeserializerMark.deserialize_all(tracks_mark_response.body) if tracks_mark_response
    tracks_team6_response = @connector_team6.get_all_tracks
    tracks_team6 = TracksDeserializerTeam6.deserialize_all(tracks_team6_response.body) if tracks_team6_response
    (tracks_mark or []) + (tracks_team6 or []) + Track.all
  end

  def get_tracks_of(user)
    tracks_from_mark = @connector_mark.get_tracks_of(user)
    tracks_from_mark = tracks_from_mark.body if tracks_from_mark
    tracks_from_db = Track.all.map(&:waypoints)
    (tracks_from_mark or []) + tracks_from_db
  end

  def create_track(track, current_user)
    response = @connector_mark.create_track(track)
    unless response
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

  private

  def name_conflict(response)
    response.status == 409
  end
end
