# -*- coding: utf-8 -*-

require 'active_support/all'
require 'json/pure'

class Facebook::Graph

  def [](key)
    if key.present?
      self.class.separate @graph[key.to_s]
    end
  end

  def id
    @graph['id']
  end

  def initialize(data)
    @graph = data.stringify_keys
  end

  def name
    @graph['name']
  end

  def keys
    @graph.keys
  end

  def key?(key)
    keys.key? key
  end

  def to_s
    @graph.to_s
  end

  class << self
    def parse(json_string = nil)
      if json_string
        new(JSON.parse json_string)
      else
        new({})
      end
    end

    def separate(data)
      case data
      when nil
        nil
      when Hash
        new data
      when Array
        data.collect { |datum| separate datum }
      else
        data
      end
    end
  end
end
