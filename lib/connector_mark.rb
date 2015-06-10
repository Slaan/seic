require 'logger'
require 'faraday_middleware'

class ConnectorMark

  API_URL = 'https://trackyourtracks.eu-gb.mybluemix.net/api'
  if Rails.env.production?
    COMMUNITY_NAME = ENV.fetch('MARK_COMMUNITY_NAME')
    COMMUNITY_PASSWORD = ENV.fetch('MARK_USER_PASSWORD')
    # Tokens are permanent for group mark
    COMMUNITY_TOKEN = ENV.fetch('MARK_COMMUNITY_TOKEN')
  else
    COMMUNITY_NAME = 'Tindbike'
    COMMUNITY_PASSWORD = '1QfO9TWEpXbwPJIKOQPq'
    # Tokens are permanent for group mark
    COMMUNITY_TOKEN = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0aW5kYmlrZSJ9.EZP2KljNuxOXO0uHG9T6Uo1yG-bbKsBRgy8Ak98-2jU'
  end
  
  attr_reader :connection

  def initialize(connection = nil)
    if connection
      @connection = connection
    else
      @connection = setup_community_connection
    end
  end

  def setup_community_connection
    setup_connection(COMMUNITY_NAME, COMMUNITY_PASSWORD)
  end

  def setup_connection(user_name, user_password)
    Faraday.new API_URL, :ssl => {:verify => false} do |builder|
      builder.headers[:token] = COMMUNITY_TOKEN
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

  def connection(params)
    if params[:user]
      user = params[:user]
      connection = setup_connection(user.username, user.password_digest)
    elsif params[:username] and params[:password]
      connection = setup_connection(params[:username], params[:password])
    end
    ConnectorMark.new(connection)
  end

  def login(connection)
    connection.get('communities/' + COMMUNITY_NAME.downcase).body["token"]
  end

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
    @connection.put(path) do |request|
      request.body = JSON.generate(params) if params
      p "Put body: #{request.body}"
    end
  end

  def delete(path)
    @connection.delete(path)
  end

  module ApiMethods

    TRACKS_PATH = "tracks"
    USERS_PATH = "users"

    def create_user(user)
      setup_community_connection
      response = post(USERS_PATH,
        user_to_hash(user))
      response
    end

    def update_user(username, old_user, new_user)
      #      binding.pry
      user = user_diff(old_user, new_user)
      put("#{USERS_PATH}/#{username.downcase}",
        user_to_hash(user))
    end

    def get_user(user)
      get("#{USERS_PATH}/#{user.username.downcase}")
    end

    def user_to_hash(user)
      hash = {}
      hash[:user_name] = user.username if user.username
      hash[:user_mail] = user.email if user.email
      hash[:user_password] = user.password_digest if user.password_digest
      hash
    end

    def user_diff(old_user, new_user)
      user_dto = User.new
      user_dto.username = new_user.username if not old_user.username == new_user.username
      user_dto.email = new_user.email if not old_user.email == new_user.email
      user_dto.password_digest = new_user.password_digest if (not old_user.password_digest == new_user.password_digest)
      user_dto
    end

    def delete_user(user)
      delete("#{USERS_PATH}/#{user.username.downcase}")
    end

    def create_track(track)
      post(TRACKS_PATH,
        track_to_hash(track))
    end

    def update_track(old_name, track)
      put("#{TRACKS_PATH}/#{old_name.downcase}",
        track_to_hash(track))
    end

    def track_to_hash(track)
      {track_name: track.name,
        track_description: track.description,
        track_keywords: track.tags,
        track_geojson: track.waypoints}
    end

    def delete_track(track)
      delete(TRACKS_PATH + "/" + track.name.downcase)
    end

    def get_all_tracks
      get(TRACKS_PATH)
    end

    def get_track(trackname)
      get(TRACKS_PATH + "/" + trackname.downcase)
    end

    def get_tracks_of(user)
      get("#{USERS_PATH}/#{user.username.downcase}/#{TRACKS_PATH}")
    end

    def query_tracks(params = nil)
      get(TRACKS_PATH, params)
    end
  end

  include ApiMethods
end

