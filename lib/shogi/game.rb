# -*- coding: utf-8 -*-

class Shogi::Game
  include Mongoid::Document
  include Mongoid::Timestamps
  field :win, type: String
  embeds_many :boards, class_name: 'Shogi::Board', inverse_of: :game
  belongs_to :black, class_name: 'Shogi::Player', inverse_of: 'boards_black'
  belongs_to :white, class_name: 'Shogi::Player', inverse_of: 'boards_white'

  after_initialize :make_board

  def finished?
    !!self.win
  end

  def last
    self.boards.last
  end

  def length
    if self.boards.count >= 1
      self.boards.count - 1
    else
      0
    end
  end

  def players
    result = []
    result << self.black if self.black
    result << self.white if self.white
    result
  end

private
  def make_board
    self.boards << Shogi::Board.make if self.boards.blank?
  end
end
