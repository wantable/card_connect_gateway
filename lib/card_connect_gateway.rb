require 'card_connect_gateway/version'
require 'card_connect_gateway/configuration'
require 'card_connect_gateway/base'
require 'card_connect_gateway/base_request'
require 'card_connect_gateway/base_response'
require 'card_connect_gateway/authorization'
require 'card_connect_gateway/capture'
require 'card_connect_gateway/void'

module CardConnectGateway

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  def self.authorization(options={})
    Authorization.new(options)
  end

  def self.capture(options={})
    Capture.new(options)
  end

  def self.void(options={})
    Void.new(options)
  end
end
