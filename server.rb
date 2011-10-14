require 'sinatra'
# require 'mongoid'
require 'sinatra/reloader' if development?
require 'open-uri'
require 'haml'
require 'sass'
require 'yaml'
require 'httpclient'
require 'json/pure'
require 'uri'

# require './config/mongoid'
# Dir["./models/*.rb"].each {|file| require file }

use Rack::Session::Cookie, :key => 'rack.session',
                           :domain => 'shogiplus.cloudfoundry.com',
                           :path => '/',
                           :expire_after => 2592000,
                           :secret => 'd4963334c2748abf3ac9ebefbc31928c'

set :haml, { ugly: true }
set :public, File.dirname(__FILE__) + '/public'

helpers do
  def number_with_delimiter(number)
    parts = number.to_s.to_str.split('.')
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
    parts.join('.')
  end
end

get '/' do
  if session[:access_token]
    haml :index
  else
    fb = YAML.load_file('./config/facebook.yml')
    redirect "https://graph.facebook.com/oauth/authorize?client_id=#{fb['app_id']}&redirect_uri=#{URI.encode "https://shogiplus.cloudfoundry.com/session/new"}"
  end
end

post '/' do
  redirect '/'
end

get '/session/new' do
  session[:access_token] = nil
  if params[:code]
    fb = YAML.load_file('./config/facebook.yml')
    client = HTTPClient.new
    begin
      url = "https://graph.facebook.com/oauth/access_token?client_id=#{fb['app_id']}&redirect_uri=#{URI.encode "https://shogiplus.cloudfoundry.com/session/new"}&client_secret=#{fb['app_secret']}&code=#{params[:code]}"
      result = client.get_content url
      pairs = result.split '&'
      pairs.each do |pair|
        key, value = pair.split '='
        if key == 'access_token'
          session[:access_token] = value
          break
        end
      end
      redirect '/'
    rescue
      'failure'
    end
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
