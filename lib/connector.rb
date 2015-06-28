module Connector

  CHECK_INTERVAL_IN_SEC = 1 * 60

  def setup_community_connection
    setup_connection(self.class::COMMUNITY_NAME, self.class::COMMUNITY_PASSWORD)
  end

  def setup_connection(user_name, user_password)
    Faraday.new self.class::API_URL, :ssl => {:verify => false} do |builder|
      builder.use FaradayExceptions
      builder.headers[:token] = self.class::COMMUNITY_TOKEN
      builder.options.timeout = 5
      builder.options.open_timeout = 3
      builder.use Faraday::Request::Retry
      builder.request :json
      builder.response :json, :content_type => /\bjson$/
      builder.use :instrumentation
      builder.use FaradayMiddleware::ParseJson, content_type: 'application/json'
      builder.use Faraday::Response::Logger, Logger.new('faraday.log')
      builder.use Faraday::Request::BasicAuthentication, user_name, user_password
      builder.adapter Faraday.default_adapter
    end
  end

  def login(connection)
    connection.get('communities/' + self.class::COMMUNITY_NAME.downcase).body["token"]
  end

  # Used to retrieve existing records
  def get(path, params = nil)
    return unless try_connection?
    response = @connection.get(path) do |request|
      request.params = params if (params and request)
    end
    check_up?(response)
  end

  # Used to create new records
  def post(path, params = nil)
    return unless try_connection?
    response = @connection.post(path) do |request|
      request.body = JSON.generate(params) if params.kind_of? Hash
      request.body = params.to_json if params.kind_of? ActiveRecord::Base
      p "Posting body: #{request.body}"
    end
    check_up?(response)
  end

  # Used to update existing records
  def put(path, params = nil)
    return unless try_connection?
    response = @connection.put(path) do |request|
      request.body = JSON.generate(params) if params
      p "Put body: #{request.body}"
    end
    check_up?(response)
  end

  def delete(path)
    return unless try_connection?
    response = @connection.delete(path)
    check_up?(response)
  end

  def check_up?(response)
    if response
      response
    else
      set_down
    end
  end

  def up?
    @up
  end

  def try_connection?
    @up || interval_passed
  end

  def set_down
    @down_since = Time.now
    @up = false
    p "Backend seems to be down."
    nil
  end

  def interval_passed
    if (Time.now - @down_since) > CHECK_INTERVAL_IN_SEC
      @up = true
    else
      false
    end
  end
end
