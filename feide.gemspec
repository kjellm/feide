# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "feide/version"

development_files = %w(Gemfile .gitignore)

Gem::Specification.new do |s|
  s.name        = "feide"
  s.version     = Feide::VERSION
  s.author      = "Kjell-Magne Øierud"
  s.email       = ["kjellm@oierud.net"]
  s.homepage    = "https://github.com/kjellm/feide"
  s.license     = "MIT"
  s.summary     = %q{Library that aids in making a SAML Service Provider for the FEIDE SAML Identity Provider}
  s.description = %q{Library that aids in making a SAML Service Provider for the FEIDE SAML Identity Provider}
  
  s.files         = `git ls-files`.split("\n") - development_files
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.8.7'

  s.add_runtime_dependency "saml"
end
