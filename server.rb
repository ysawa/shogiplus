# -*- coding: utf-8 -*-

require 'sinatra'
require 'mongoid'
require 'sinatra/reloader' if development?
require 'open-uri'
require 'haml'
require 'sass'
require 'yaml'
require 'httpclient'
require 'json/pure'
require 'uri'
require 'active_support/all'
require './lib/facebook'

# require './config/mongoid'
# Dir["./models/*.rb"].each {|file| require file }

use Rack::Session::Cookie, key: 'rack.session',
                           domain: 'shogiplus.cloudfoundry.com',
                           path: '/',
                           expire_after: 2592000,
                           secret: 'd4963334c2748abf3ac9ebefbc31928c'

set :haml, { ugly: true, format: :html5 }
set :public, File.dirname(__FILE__) + '/public'

configure do
  fb_config = YAML.load_file('./config/facebook.yml').stringify_keys
  set :app_id, fb_config['app_id']
  set :app_secret, fb_config['app_secret']
  set :redirect_uri, fb_config['login_uri']
end

helpers do
  include Facebook::Helper
  include Shogi::Helper

  def number_with_delimiter(number)
    parts = number.to_s.to_str.split('.')
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
    parts.join('.')
  end

  def partial(renderer, template, options = {})
    options = options.merge({layout: false})
    template = "_#{template.to_s}".to_sym
    method(renderer).call(template, options)
  end

  def partial_erb(template, options)
    partial(:erb, template, options)
  end

  def partial_haml(template, options = {})
    partial(:haml, template, options = {})
  end
end

get '/' do
  if session[:access_token]
    @fb_client = Facebook::Client.new app_id: settings.app_id, app_secret: settings.app_secret, redirect_uri: settings.redirect_uri, access_token: session[:access_token]
    @me = @fb_client.get_graph 'me'
    if @me
      haml :index
    else
      session[:access_token] = nil
      redirect @fb_client.authorize_url
    end
  else
    @fb_client = Facebook::Client.new app_id: settings.app_id, app_secret: settings.app_secret, redirect_uri: settings.redirect_uri
    redirect @fb_client.authorize_url
  end
end

post '/' do
  redirect '/'
end

get '/session/new' do
  session[:access_token] = nil
  if params[:code]
    @fb_client = Facebook::Client.new app_id: settings.app_id, app_secret: settings.app_secret, redirect_uri: settings.redirect_uri
    session[:access_token] = @fb_client.get_access_token_from_code params[:code]
    redirect '/'
  else
    redirect '/'
  end
end

delete '/session' do
  session[:access_token] = nil
end

get '/main.css' do
  sass :main
end

not_found do
  "Not Found"
end

error 403 do
  "Invalid Format"
end
