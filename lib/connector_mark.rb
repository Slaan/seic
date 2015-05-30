require 'logger'
require 'faraday_middleware'

class ConnectorMark

  API_URL = 'https://trackyourtracks.eu-gb.mybluemix.net/api'
  COMMUNITY_NAME = 'Tindbike'
  COMMUNITY_PASSWORD = '1QfO9TWEpXbwPJIKOQPq'
  USER_NAME = 'tindbike'
  USER_PASSWORD = COMMUNITY_PASSWORD

  attr_reader :connection

  def initialize
    community_connection = setup_connection(COMMUNITY_NAME, COMMUNITY_PASSWORD)
    @community_token = login(community_connection)
    @connection = setup_connection(USER_NAME, USER_PASSWORD)
  end

  def setup_connection(user_name, user_password)
    Faraday.new API_URL do |builder|
      builder.headers[:token] = @community_token if @community_token
      builder.use Faraday::Request::Retry
      builder.request :json
      builder.response :json, :content_type => /\bjson$/
      builder.use :instrumentation
      builder.use FaradayMiddleware::ParseJson, content_type: 'application/json'
      builder.use Faraday::Response::Logger, Logger.new('faraday.log')
      builder.use Faraday::Request::BasicAuthentication, user_name, user_password
      builder.use Faraday::Response::Logger
      builder.adapter Faraday.default_adapter
    end
  end

  def connection(user)
    @connection = setup_connection(user.username, user.password_digest)
    self
  end

  def login(connection)
    connection.get('communities/' + USER_NAME.downcase).body["token"]
  end

  # first: login community(basic auth) => token
  # => bei tracks und user aktionen: immer token mitschicken

  # Used to retrieve existing records
  def get(path, params = nil)
    @connection.get(path) do |request|
      request.params = params if params
    end
  end

  # Used to create new records
  def post(path, params = nil)
    @connection.post(path) do |request|
      request.body = JSON.generate(params) if params.kind_of? Hash
      request.body = params.to_json if params.kind_of? ActiveRecord::Base
      p "Posting body: #{request.body}"
      end
  end

  # Used to update existing records
  def put(path, params = nil)
    @connection.post(path) do |request|
      request.body = JSON.generate(params) if params
    end
  end

  def delete(path)
    @connection.delete(path)
  end

  module ApiMethods

    TRACKS_PATH = "tracks"
    USERS_PATH = "users"

    def create_user(user)
      post(USERS_PATH,
        user_to_hash(user))
    end

    def update_user(user)
      put(USERS_PATH,
        user_to_hash(user))
    end

    def get_user(user)
      get("#{USERS_PATH}/#{user.name}")
    end

    def user_to_hash(user)
      {user_name: user.username,
        user_mail: user.email,
        user_password: user.password_digest}
    end

    def delete_user(user)
      delete("#{USERS_PATH}/#{user.username}")
    end

    def create_track(track)
      post(TRACKS_PATH,
        track_to_hash(track))
    end

    def update_track(track)
      put(TRACKS_PATH,
        track_to_hash(track))
    end

    def track_to_hash(track)
      {track_name: track.name,
        track_description: track.description,
        track_keywords: track.tags,
        track_geojson: track.waypoints}
    end

    def delete_track(track)
      delete(TRACKS_PATH + "/" + track.name)
    end

    def get_all_tracks
      get(TRACKS_PATH)
    end

    def get_track(track)
      get(TRACKS_PATH + "/" + track.name)
    end

    def get_tracks_of(user)
      get("#{USERS_PATH}/#{user.username}/#{TRACKS_PATH}")
    end
  end

  include ApiMethods
end

