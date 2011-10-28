# -*- coding: utf-8 -*-

require 'fakeweb'
require 'httpclient'

class Net::HTTPResponse

  def contenttype
    self.content_type.to_s
  end

end

module Net::HTTPHeader

  def [](key)
    if key.downcase == 'content-encoding' # fix for soap4r
      @header[key.downcase] || []
    else
      a = @header[key.downcase]
      return unless a
      a.join(', ')
    end
  end

end


class HTTPClient

  module FakeWebHTTPClientResponseWrapper

    def status
      self.code.to_i
    end

    def content
      self.body
    end

  end

  def do_get_block_with_fakeweb(req, proxy, conn, &block)
    method  = req.header.request_method.downcase.to_sym
    uri     = req.header.request_uri

    if FakeWeb.registered_uri?(method, uri)
      response = FakeWeb.response_for(method, uri, &block).extend(FakeWebHTTPClientResponseWrapper)
      conn.push(response)
    elsif FakeWeb.allow_net_connect?
      do_get_block_without_fakeweb(req, proxy, conn, &block)
    else
      uri = FakeWeb::Utility.strip_default_port_from_uri(uri)
      raise FakeWeb::NetConnectNotAllowedError,
            "Real HTTP connections are disabled. Unregistered request: #{method} #{uri}"
    end
  end
  alias_method :do_get_block_without_fakeweb, :do_get_block
  alias_method :do_get_block, :do_get_block_with_fakeweb

end

FakeWeb.register_uri(
  :get,
  %r|^https://graph\.facebook\.com/oauth/access_token|,
  body: 'access_token=access_token&expires=5108'
)

FakeWeb.register_uri(
  :get,
  %r|^https://graph\.facebook\.com/\w+$|,
  body: '{ "name": "Taro Tanaka", "id": "123456789" }'
)
