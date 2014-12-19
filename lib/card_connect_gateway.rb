require 'card_connect_gateway/version'
require 'card_connect_gateway/configuration'

module CardConnectGateway

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end
