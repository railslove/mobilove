# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'mobilove/version'

Gem::Specification.new do |s|
  s.name         = "mobilove"
  s.version      = Mobilove::VERSION
  s.authors      = ["Red Davis", "Tim Schneider"]
  s.email        = "tim@railslove.com"
  s.homepage     = "http://github.com/railslove/mobilove"
  s.summary      = "Small wrapper for sending text messages with mobilant.de"
  s.description  = "Use mobilove to send text messages with Ruby. Account on mobilant.de required."

  s.add_dependency 'rest-client'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

  s.files        = `git ls-files app lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
end
