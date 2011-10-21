# -*- coding: utf-8 -*-

class Shogi::Piece
  include Mongoid::Document
  include Mongoid::Timestamps
  field :black, type: Boolean
  field :in_hand, type: Boolean
  field :role, type: String
  field :position, type: Array
  embedded_in :board, class_name: 'Shogi::Piece', inverse_of: :pieces

  def attackable?(target)
    return false if self.in_hand
    move = target - self.position
    Shogi::Logic.can_move?(self.role, move.x, move.y, self.black)
  end

  def black?
    !!self.black
  end

  def can_move?(target)
    return true if self.in_hand
    move = target - self.position
    Shogi::Logic.can_move?(self.role, move.x, move.y, self.black)
  end

  def on_board?
    return false if self.in_hand?
    return false if self.position.out_of_board?
    true
  end

  def out_of_board?
    return false if in_hand?
    return false if on_board?
    true
  end

  def position
    Shogi::Position.new(read_attribute :position)
  end

  def position=(position)
    write_attribute :position, position.to_a
  end

  def right_role?
    Shogi::Logic.role? self.role
  end

  def white?
    !self.black
  end

  def x
    self.position.x
  end

  def y
    self.position.y
  end

  class << self
    def piece(role, position, black, in_hand = false)
      new(role: role, position: position, black: black, in_hand: in_hand)
    end

    def on(position)
      criteria.where(position: position).first
    end
  end
end
