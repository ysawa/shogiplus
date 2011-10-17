# -*- coding: utf-8 -*-

module Shogi

  def root
    File.dirname(__FILE__)
  end

  module_function :root

  autoload :Logic, File.join(root, '/shogi/logic.rb')
  autoload :UnknownRole, File.join(root, '/shogi/unknown_role.rb')
end
