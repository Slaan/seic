class ConnectorFactory
  def self.connection
    @connector ||= DualConnector.new
  end
end
