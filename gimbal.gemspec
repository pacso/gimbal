# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'gimbal/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{Gimbal::RUBY_VERSION}"
  s.authors = ['Jon Pascoe']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Based on Suspenders from thoughtbot, Gimbal is a base Rails project I use
to streamline the beginning of my Rails projects.
  HERE

  s.email = 'jon.pascoe@me.com'
  s.executables = ['gimbal']
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/pacso/gimbal'
  s.license = 'MIT'
  s.name = 'gimbal'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "A Rails App Generator."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Gimbal::VERSION

  s.add_dependency 'bundler', '~> 1.3'
  s.add_dependency 'rails', Gimbal::RAILS_VERSION

  s.add_development_dependency 'rspec', '~> 3.6'
end
