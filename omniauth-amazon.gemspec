# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/amazon/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-amazon'
  spec.version       = OmniAuth::Amazon::VERSION
  spec.authors       = ['Stafford Brunk']
  spec.email         = ['stafford.brunk@gmail.com']
  spec.description   = 'Amazon Business OAuth2 strategy for OmniAuth'
  spec.summary       = 'Amazon Business OAuth2 strategy for OmniAuth'
  spec.homepage      = 'https://github.com/CanalWestStudio/omniauth-amazon'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.1'

  spec.files         = Dir['lib/**/*', 'LICENSE.txt', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'omniauth', '~> 2.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.8'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
