require 'card_connect_gateway/version'
require 'card_connect_gateway/configuration'
require 'card_connect_gateway/helpers'
require 'card_connect_gateway/base'
require 'card_connect_gateway/base_request'
require 'card_connect_gateway/base_response'
require 'card_connect_gateway/authorization'
require 'card_connect_gateway/capture'
require 'card_connect_gateway/void'
require 'card_connect_gateway/profile'

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

  def self.create_profile(options={})
    Profile.new(options)
  end

  def self.update_profile(options={})
    # same as create. just requires the profile id be filled in on the api side
    Profile.new(options) 
  end

  def self.capture(options={})
    Capture.new(options)
  end

  def self.void(options={})
    Void.new(options)
  end
end
