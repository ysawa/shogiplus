# -*- coding: utf-8 -*-

class Shogi::Board
  include Mongoid::Document
  include Mongoid::Timestamps
  field :number, type: Integer
  embedded_in :game, class_name: 'Shogi::Game', inverse_of: :boards
  embeds_many :pieces, class_name: 'Shogi::Piece', inverse_of: :board

  def black
    self.game and self.game.black
  end

  def copy
    board = self.dup
    board.game = self.game if self.game
    board.pieces.clear
    board.number = self.number + 1 if self.number
    self.pieces.each do |piece|
      board.pieces << piece.dup
    end
    board
  end

  def move_black?
    (self.number).odd?
  end

  def move_white?
    !move_white?
  end

  def to_s
    board = "##{self.number || "undef"}\n"
    board += "9     8     7     6     5     4     3     2     1\n"
    1.upto(9).each do |y|
      9.downto(1).each do |x|
        piece = self.pieces.position(x, y)
        if piece
          board += "%4s" % piece.role[0, 4]
          if piece.black?
            board += "B "
          else
            board += "W "
          end
        else
          board += "      "
        end
      end
      board += "#{y}\n"
    end
    board
  end

  def white
    self.game and self.game.white
  end

  class << self
    # initialize board and place all pieces
    def arrange
      board = new
      board.number = 1
      board.pieces << Shogi::Piece.piece('ou', 5, 1, false)
      board.pieces << Shogi::Piece.piece('ou', 5, 9, true)
      board.pieces << Shogi::Piece.piece('kin', 4, 1, false)
      board.pieces << Shogi::Piece.piece('kin', 6, 1, false)
      board.pieces << Shogi::Piece.piece('kin', 4, 9, true)
      board.pieces << Shogi::Piece.piece('kin', 6, 9, true)
      board.pieces << Shogi::Piece.piece('gin', 3, 1, false)
      board.pieces << Shogi::Piece.piece('gin', 7, 1, false)
      board.pieces << Shogi::Piece.piece('gin', 3, 9, true)
      board.pieces << Shogi::Piece.piece('gin', 7, 9, true)
      board.pieces << Shogi::Piece.piece('keima', 2, 1, false)
      board.pieces << Shogi::Piece.piece('keima', 8, 1, false)
      board.pieces << Shogi::Piece.piece('keima', 2, 9, true)
      board.pieces << Shogi::Piece.piece('keima', 8, 9, true)
      board.pieces << Shogi::Piece.piece('kyosha', 1, 1, false)
      board.pieces << Shogi::Piece.piece('kyosha', 9, 1, false)
      board.pieces << Shogi::Piece.piece('kyosha', 1, 9, true)
      board.pieces << Shogi::Piece.piece('kyosha', 9, 9, true)
      board.pieces << Shogi::Piece.piece('kaku', 2, 2, false)
      board.pieces << Shogi::Piece.piece('hisha', 8, 2, false)
      board.pieces << Shogi::Piece.piece('hisha', 2, 8, true)
      board.pieces << Shogi::Piece.piece('kaku', 8, 8, true)
      1.upto(9).each do |x|
        board.pieces << Shogi::Piece.piece('fu', x, 3, false)
        board.pieces << Shogi::Piece.piece('fu', x, 7, true)
      end
      board
    end
  end
private
end
