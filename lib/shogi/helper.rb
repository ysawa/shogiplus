# -*- coding: utf-8 -*-

module Shogi::Helper
  def player_side_from_piece(piece)
    if piece.black
      'black'
    else
      'white'
    end
  end
end
