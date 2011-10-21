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

  # check if not being checkmated,
  # not being out of board,
  # not being on a proponent piece,
  # and being valid movement
  def can_move?(piece, position)
    position = Shogi::Position.new position
    return false unless have_piece? piece
    unless piece.black? ^ move_black? # see if it's proponent turn
      return false
    end
    return false if position.out_of_board?
    if piece.in_hand?
      if position_have_proponent_piece?(position) or
          position_have_opponent_piece?(position) or
          checkmate?
        return false
      else
        return true
      end
    end
    return false if position_have_proponent_piece? position
    return false unless piece.can_move? position
    heap = piece.attributes.dup
    piece.position = position
    piece.in_hand = false
    if checkmate?
      piece.attributes = heap
      return false
    end
    piece.attributes = heap
    true
  end

  def checkmate?
    false
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

  def copy_and_move(piece, position)
    board = self.copy
    target = board.find_piece_by_position(piece.position)
    board.move(target, position)
    board
  end

  def find_piece_by_position(position)
    self.pieces.each do |piece|
      return piece if piece.x == position[0] and piece.y == position[1]
    end
    nil
  end

  def have_piece?(piece)
    pieces.include? piece
  end

  def move(piece, position)
    raise Shogi::UnexpectedMovement unless can_move?(piece, position)
    opponent = find_piece_by_position(position)
    if opponent and (move_black? ^ opponent.black?) # see if opponent is really opponent
      opponent.in_hand = true
      opponent.position = nil
      opponent.black = move_black?
    end
    piece.position = position
    piece.in_hand = false
    nil
  end

  def move_black?
    (self.number).odd?
  end

  def move_white?
    !move_black?
  end

  def pieces_black_in_hand
    pieces.select { |piece| piece.blank? and piece.in_hand? }
  end

  def pieces_black_on_board
    pieces.select { |piece| piece.blank? and piece.on_board? }
  end

  def pieces_in_hand
    pieces.select { |piece| piece.in_hand? }
  end

  def pieces_on_board
    pieces.select { |piece| piece.on_board? }
  end

  def pieces_white_in_hand
    pieces.select { |piece| piece.white? and piece.in_hand? }
  end

  def pieces_white_on_board
    pieces.select { |piece| piece.white? and piece.on_board? }
  end

  def position_have_piece?(position)
    return true if find_piece_by_position(position)
    false
  end

  def position_have_opponent_piece?(position)
    piece = find_piece_by_position(position)
    if piece and (move_black? ^ piece.black?)
      return true
    end
    false
  end

  def position_have_proponent_piece?(position)
    piece = find_piece_by_position(position)
    if piece and !(move_black? ^ piece.black?)
      return true
    end
    false
  end

  def proponent
    if move_black?
      'black'
    else
      'white'
    end
  end

  def to_s
    board = "##{self.number || "undef"}\n"
    board += "9     8     7     6     5     4     3     2     1\n"
    1.upto(9).each do |y|
      9.downto(1).each do |x|
        target = [x, y]
        piece = self.find_piece_by_position(target)
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
    board += "W: "
    pieces_white_in_hand.each do |piece|
      board += "#{piece.role} "
    end
    board += "\nB: "
    pieces_black_in_hand.each do |piece|
      board += "#{piece.role} "
    end
    board += "\n"
    board
  end

  def white
    self.game and self.game.white
  end

  class << self
    # initialize board and place all pieces
    def arrange
      board = new
      board.number = 0
      board.pieces << Shogi::Piece.piece('ou', [5, 1], false)
      board.pieces << Shogi::Piece.piece('ou', [5, 9], true)
      board.pieces << Shogi::Piece.piece('kin', [4, 1], false)
      board.pieces << Shogi::Piece.piece('kin', [6, 1], false)
      board.pieces << Shogi::Piece.piece('kin', [4, 9], true)
      board.pieces << Shogi::Piece.piece('kin', [6, 9], true)
      board.pieces << Shogi::Piece.piece('gin', [3, 1], false)
      board.pieces << Shogi::Piece.piece('gin', [7, 1], false)
      board.pieces << Shogi::Piece.piece('gin', [3, 9], true)
      board.pieces << Shogi::Piece.piece('gin', [7, 9], true)
      board.pieces << Shogi::Piece.piece('keima', [2, 1], false)
      board.pieces << Shogi::Piece.piece('keima', [8, 1], false)
      board.pieces << Shogi::Piece.piece('keima', [2, 9], true)
      board.pieces << Shogi::Piece.piece('keima', [8, 9], true)
      board.pieces << Shogi::Piece.piece('kyosha', [1, 1], false)
      board.pieces << Shogi::Piece.piece('kyosha', [9, 1], false)
      board.pieces << Shogi::Piece.piece('kyosha', [1, 9], true)
      board.pieces << Shogi::Piece.piece('kyosha', [9, 9], true)
      board.pieces << Shogi::Piece.piece('kaku', [2, 2], false)
      board.pieces << Shogi::Piece.piece('hisha', [8, 2], false)
      board.pieces << Shogi::Piece.piece('hisha', [2, 8], true)
      board.pieces << Shogi::Piece.piece('kaku', [8, 8], true)
      1.upto(9).each do |x|
        board.pieces << Shogi::Piece.piece('fu', [x, 3], false)
        board.pieces << Shogi::Piece.piece('fu', [x, 7], true)
      end
      board
    end
  end
private
end
