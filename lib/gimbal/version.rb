module Gimbal
  RAILS_VERSION = '~> 4.2'.freeze
  RUBY_VERSION = IO.read("#{File.dirname(__FILE__)}/../../.ruby-version").strip.freeze
  VERSION = '0.2.0'.freeze
end
