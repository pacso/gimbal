module Gimbal
  RAILS_VERSION = '~> 5.1'.freeze
  RUBY_VERSION = IO.read("#{File.dirname(__FILE__)}/../../.ruby-version").strip.freeze
  VERSION = '0.3.0'.freeze
end
