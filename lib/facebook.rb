# -*- coding: utf-8 -*-

module Facebook

  def root
    File.dirname(__FILE__)
  end

  module_function :root

  class UnexpectedArgument < StandardError; end

  autoload :Client, File.join(root, '/facebook/client.rb')
  autoload :Helper, File.join(root, '/facebook/helper.rb')
  autoload :Graph, File.join(root, '/facebook/graph.rb')
end
