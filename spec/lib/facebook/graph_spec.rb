# -*- coding: utf-8 -*-
#
require File.dirname(__FILE__) + '/../../spec_helper'

describe Facebook::Graph do
  describe 'parse' do
    it 'can take blank' do
      @graph = Facebook::Graph.parse
      @graph.keys.should be_blank
    end

    it 'can take nil' do
      @graph = Facebook::Graph.parse nil
      @graph.keys.should be_blank
    end

    it 'can take formatted json of graph' do
      @graph = Facebook::Graph.parse '{ "id": "1", "name": "Taro Tanaka" }'
      @graph.keys.size.should == 2
      @graph.keys.should include 'id'
      @graph.keys.should include 'name'
      @graph.id.should == '1'
      @graph.name.should == 'Taro Tanaka'
    end
  end
end
