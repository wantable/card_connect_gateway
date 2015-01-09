# -*- encoding: utf-8 -*-

# -- this is magic line that ensures "../lib" is in the load path -------------
$:.push File.expand_path("../lib", __FILE__)

require 'card_connect_gateway/version'

Gem::Specification.new do |s|
  s.name        = 'card_connect_gateway'
  s.version     = CardConnectGateway::VERSION
  s.date        = '2014-12-15'
  s.summary     = "Card Connect Gateway"
  s.description = "A Ruby API client that interfaces with card connect's REST api for credit card payment processing."
  s.authors     = ["Casey Sobrilsky"]
  s.email       = 'it@wantable.com'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for
  s.homepage    = 'http://github.com/wantable/card_connect_gateway'
  s.license       = 'MIT'
  s.add_dependency('rest_client')
  s.add_dependency('i18n')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rake')
  s.add_development_dependency('jasmine')
  s.add_development_dependency('guard')
  s.add_development_dependency('guard-coffeescript')
end