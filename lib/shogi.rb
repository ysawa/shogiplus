# -*- coding: utf-8 -*-

module Shogi

  def root
    File.dirname(__FILE__)
  end

  module_function :root

  autoload :Board, File.join(root, '/shogi/board.rb')
  autoload :Helper, File.join(root, '/shogi/helper.rb')
  autoload :Game, File.join(root, '/shogi/game.rb')
  autoload :Logic, File.join(root, '/shogi/logic.rb')
  autoload :Piece, File.join(root, '/shogi/piece.rb')
  autoload :Player, File.join(root, '/shogi/player.rb')
  autoload :UnknownRole, File.join(root, '/shogi/unknown_role.rb')
end
