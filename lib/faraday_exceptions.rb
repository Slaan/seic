  class FaradayExceptions < Faraday::Middleware

    def call(env)
      begin
        @app.call(env)
      rescue Faraday::Error::ConnectionFailed, Faraday::Error::TimeoutError => e
        url = env[:url].to_s.gsub(env[:url].path, '')
        $stderr.puts "The server at #{url} is either unavailable or is not currently accepting requests. Please try again in a few minutes."
      end
    end

  end
