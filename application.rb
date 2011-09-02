require "rubygems"
require "bundler"

module Snoop
  class Application

    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    def self.env
      @_env ||= ENV['RACK_ENV'] || 'development'
    end

    def self.routes
      @_routes ||= eval(File.read('./config/routes.rb'))
    end

    # Initialize the application
    def self.initialize!
      Cramp::Websocket.backend = :rainbows
    end

  end
end

Bundler.require(:default, Snoop::Application.env)

require 'erb'
require 'yaml'
require 'stringio'
require 'yajl'

$: << Snoop::Application.root('lib/ruby-em-irc2/lib')
require 'em-ruby-irc'

# Preload application classes
Dir['./app/**/*.rb'].each {|f| require f}

