module Connector

  def setup_community_connection
    setup_connection(self.class::COMMUNITY_NAME, self.class::COMMUNITY_PASSWORD)
  end

  def setup_connection(user_name, user_password)
    Faraday.new self.class::API_URL, :ssl => {:verify => false} do |builder|
      builder.headers[:token] = self.class::COMMUNITY_TOKEN
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
    connection = setup_connection(user.username, user.password_digest)
    ConnectorMark.new(connection)
  end

  def connection(username, password)
    connection = setup_connection(username, password)
    ConnectorMark.new(connection)
  end

  def login(connection)
    connection.get('communities/' + self.class::COMMUNITY_NAME.downcase).body["token"]
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

end
