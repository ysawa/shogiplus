# -*- coding: utf-8 -*-

require 'active_support/all'
require 'httpclient'
require 'uri'

class Facebook::Client

  GRAPH_ROOT = "https://graph.facebook.com"

  # 1st. redirect to the url
  def authorize_url(scope = nil)
    url = "#{GRAPH_ROOT}/oauth/authorize?client_id=#{@app_id}&redirect_uri=#{URI.encode @redirect_uri}"
    if scope.is_a?(Array)
      url += "&#{scope.join(',')}"
    end
    url
  end

  # 2nd. get the access token from the code, and save the access token to session
  def get_access_token_from_code(code)
    client = HTTPClient.new
    begin
      url = "#{GRAPH_ROOT}/oauth/access_token"
      params = { client_id: @app_id, redirect_uri: @redirect_uri, client_secret: @app_secret, code: code }
      result = client.get_content url, params
      pairs = result.split '&'
      pairs.each do |pair|
        key, value = pair.split '='
        if key == 'access_token'
          return @access_token = value
        end
      end
    rescue
    end
  end

  # 3rd. access to Graph API
  def get_graph(path = '/', params = {})
    response = get_graph_response(path, params)
    begin
      return Facebook::Graph.parse response
    rescue
    end
  end

  def get_picture_url_from_user(user_graph)
    user_id = user_graph.id
    path = "/#{user_id}/picture"
    "#{GRAPH_ROOT}#{path}"
  end

  def initialize(params)
    params.stringify_keys!
    @app_id = params['app_id']
    @app_secret = params['app_secret']
    @access_token = params['access_token']
    @redirect_uri = params['redirect_uri']
  end

protected
  def build_url(url, params = {})
    if params.blank?
      return url
    else
      if url.include? '?' # a little stinky
        url_with_params = url + '&'
      else
        url_with_params = url
      end
      pairs = []
      params.each do |key, value|
        pairs << "#{key}=#{URI.encode value}"
      end
      url_with_params += pairs
      url_with_params
    end
  end

  def get_graph_response(path = '/', params = {})
    params.stringify_keys!
    client = HTTPClient.new
    begin
      url = "#{GRAPH_ROOT}#{path.sub(/^(\/|)/, '/')}"
      result = client.get_content url, params.merge({ access_token: @access_token })
      return result
    rescue
    end
  end
end
