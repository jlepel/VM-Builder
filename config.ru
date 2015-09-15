#require 'rubygems'
require 'sinatra'
require './app.rb'
#require 'sidekiq/web'

require File.expand_path '../app.rb', __FILE__

#use Rack::ShowExceptions
run Rack::URLMap.new('/' => Sinatra::Application)

