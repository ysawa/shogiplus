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
require 'rack/csrf'
require 'active_support/all'
require './lib/facebook'
require './lib/shogi'

require './config/mongoid'

get '/' do
  haml :index
end

post '/' do
  haml :index
end

get '/session/new' do
  session[:access_token] = nil
  if params[:code]
    @fb_client = Facebook::Client.new app_id: settings.app_id, app_secret: settings.app_secret, redirect_uri: settings.redirect_uri
    session[:access_token] = @fb_client.get_access_token_from_code params[:code]
    redirect '/'
  else
    redirect @fb_client.authorize_url
  end
end

delete '/session' do
  session[:access_token] = nil
  redirect @fb_client.authorize_url
end

get '/games' do
  @games = Shogi::Game.all
  haml :'games/index'
end

get '/games/start' do
  @game = Shogi::Game.new
  @game.save
  redirect '/games'
end

get '/games/:game_id/pieces/:id' do
end

get '/games/:id' do
  @game = Shogi::Game.find params[:id]
  haml :'games/show'
end

get '/games/:id/reload' do
  @game = Shogi::Game.find params[:id]
  haml :'shogi/_board', layout: false, locals: { game: @game, board: @game.last }
end

delete '/games/:id' do
  # params[:id]
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


set :haml, { ugly: true, format: :html5 }
set :public_folder, File.dirname(__FILE__) + '/public'

configure do
  fb_config = YAML.load_file('./config/facebook.yml').stringify_keys
  set :app_id, fb_config['app_id']
  set :app_secret, fb_config['app_secret']
  set :redirect_uri, fb_config['login_uri']
  use Rack::Session::Cookie, key: 'rack.session',
                             domain: 'shogiplus.cloudfoundry.com',
                             path: '/',
                             expire_after: 2592000,
                             secret: 'd4963334c2748abf3ac9ebefbc31928c'
  use Rack::Csrf, raise: true, skip: ['POST:/']
end

helpers do
  include Facebook::Helper
  include Shogi::Helper

  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end

  def number_with_delimiter(number)
    parts = number.to_s.to_str.split('.')
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
    parts.join('.')
  end

  def partial(renderer, template, options = {})
    options = options.merge({layout: false})
    template = template.to_s.sub(/(\/|^)(\w+)$/, '\1_\2').to_sym
    method(renderer).call(template, options)
  end

  def partial_erb(template, options)
    partial(:erb, template, options)
  end

  def partial_haml(template, options = {})
    partial(:haml, template, options)
  end
end

before do
  if session[:access_token]
    @fb_client = Facebook::Client.new app_id: settings.app_id, app_secret: settings.app_secret, redirect_uri: settings.redirect_uri, access_token: session[:access_token]
  else
    @fb_client = Facebook::Client.new app_id: settings.app_id, app_secret: settings.app_secret, redirect_uri: settings.redirect_uri
  end

  # should be logined
  unless request.path =~ %r{^(/session/new|/)$} or @fb_client.me
    redirect '/session/new'
  end
end
