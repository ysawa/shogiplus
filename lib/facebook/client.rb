# -*- coding: utf-8 -*-

require 'active_support/all'
require 'httpclient'
require 'uri'

class Facebook::Client

  # 1st. redirect to the url
  def authorize_url(scope = nil)
    url = "https://graph.facebook.com/oauth/authorize?client_id=#{@app_id}&redirect_uri=#{URI.encode @redirect_uri}"
    if scope.is_a?(Array)
      url += "&#{scope.join(',')}"
    end
    url
  end

  # 2nd. get the access token from the code, and save the access token to session
  def get_access_token_from_code(code)
    client = HTTPClient.new
    begin
      url = "https://graph.facebook.com/oauth/access_token"
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
    params.stringify_keys!
    client = HTTPClient.new
    begin
      url = "https://graph.facebook.com#{path.sub(/^(\/|)/, '/')}"
      result = client.get_content url, params.merge({ access_token: @access_token })
      return Facebook::Graph.parse result
    rescue
    end
  end

  def initialize(params)
    params.stringify_keys!
    @app_id = params['app_id']
    @app_secret = params['app_secret']
    @access_token = params['access_token']
    @redirect_uri = params['redirect_uri']
  end
end
