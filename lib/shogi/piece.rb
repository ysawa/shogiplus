# -*- coding: utf-8 -*-

class Shogi::Piece
  include Mongoid::Document
  include Mongoid::Timestamps
  field :black, type: Boolean
  field :in_hand, type: Boolean
  field :role, type: String
  field :x, type: Integer
  field :y, type: Integer
  embedded_in :board, class_name: 'Shogi::Piece', inverse_of: :pieces

  def black?
    !!self.black
  end

  def right_role?
    Shogi::Logic.role? self.role
  end

  def white?
    !self.black
  end

  class << self
    def piece(role, x, y, black, in_hand = false)
      new(role: role, x: x, y: y, black: black, in_hand: in_hand)
    end

    def position(x, y)
      criteria.where(x: x, y: y).first
    end
  end
end
