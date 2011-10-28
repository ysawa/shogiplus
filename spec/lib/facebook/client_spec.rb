# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../spec_helper'

describe Facebook::Client do
  before :each do
    @fb_client = Facebook::Client.new({ app_id: 123456789, app_secret: '0123456789abcdef', redirect_uri: 'http://example.com' })
  end

  it 'can be initialized' do
    @fb_client.should_not be_blank
  end

  it 'arguments cannot be blank' do
    %w(app_id app_secret redirect_uri).each do |attr_name|
      result = nil
      arguments = { app_id: 123456789, app_secret: '0123456789abcdef', redirect_uri: 'http://example.com' }
      arguments.delete(attr_name.to_sym)
      begin; Facebook::Client.new(arguments); rescue => e; result = e; end
      result.should_not be_nil
    end
  end

  it 'authorize_url is correct' do
    @fb_client.authorize_url.should include 'https://graph.facebook.com/'
    @fb_client.authorize_url.should include 'client_id=123456789'
  end

  it 'get_access_token_from_code connects graph.facebook.com to get access_token' do
    access_token = @fb_client.get_access_token_from_code('code')
    access_token.should == 'access_token'
  end

  it 'get_graph gets graph and parses it' do
    @fb_client.get_access_token_from_code('code')
    graph = @fb_client.get_graph('someid')
    graph.should be_a Facebook::Graph
    graph.name.should == 'Taro Tanaka'
    graph.id.should == '123456789'
  end
end
