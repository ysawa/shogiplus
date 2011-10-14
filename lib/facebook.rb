# -*- coding: utf-8 -*-

module Facebook

  def root
    File.dirname(__FILE__)
  end

  module_function :root

  autoload :Client, File.join(root, '/facebook/client.rb')
  autoload :Graph, File.join(root, '/facebook/graph.rb')
end