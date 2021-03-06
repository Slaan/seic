class ConnectorTeam6
  API_URL = 'https://trackyourtracks.mybluemix.net/api/tyt'

  COMMUNITY_NAME = 'tindbike_dev'
  COMMUNITY_PASSWORD = '1QfO9TWEpXbwPJIKOQPq'
  COMMUNITY_TOKEN = '7622838d524d4970a5326c8f6d9952c8'

  attr_accessor :community_token

  def initialize(connection = nil, up = true, down_since = nil)
    @up = up
    @down_since = down_since
    if connection
      @connection = connection
    else
      @connection = setup_community_connection
      Rails.application.config.team6_token = COMMUNITY_TOKEN || create_community_token.body["apiToken"]
      @connection = setup_community_connection
    end
  end

  module ApiMethods
    COMMUNITY_PATH = "comm"
    USER_PATH = "user"
    TRACK_PATH = "track"

    def create_community(params)
      get("#{COMMUNITY_PATH}/registrieren/#{params[:name]}/#{params[:password]}/#{params[:email]}")
    end

    def create_community_token
      get("#{COMMUNITY_PATH}/erzeugetoken/#{COMMUNITY_NAME}/#{COMMUNITY_PASSWORD}")
    end

    def create_user(user)
      community_token = Rails.application.config.team6_token
      get("#{USER_PATH}/registrieren/#{community_token}/#{user.username}/#{user.password_digest}")
    end

    def get_all_tracks
      find_tracks_longer_than(1)
    end

    def find_tracks_longer_than(length)
      community_token = Rails.application.config.team6_token
      get("#{TRACK_PATH}/findWithLength/#{community_token}/#{length}")
    end
  end

  include Connector
  include ApiMethods
end
