class ConnectorTeam6


  
  
  API_URL = 'https://trackyourtracks.mybluemix.net/api/tyt/'

  COMMUNITY_NAME = 'tindbike_dev'
  COMMUNITY_PASSWORD = '1QfO9TWEpXbwPJIKOQPq'
  COMMUNITY_TOKEN = 'fdc84465c65f402eb1548b0ef98dc935'
  
  def initialize(connection = nil)
    if connection
      @connection = connection
    else
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
      get("#{USER_PATH}/registrieren/#{COMMUNITY_TOKEN}/#{user.username}/#{user.password_digest}")
    end

    def get_all_tracks
      find_tracks_longer_than(0)
    end

    def find_tracks_longer_than(length)
      get("#{TRACK_PATH}/findWithLength/#{COMMUNITY_TOKEN}/#{length}")
    end
  end

  include Connector
  include ApiMethods
end
