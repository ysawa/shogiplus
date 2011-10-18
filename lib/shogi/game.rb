# -*- coding: utf-8 -*-

class Shogi::Game
  include Mongoid::Document
  include Mongoid::Timestamps
  embeds_many :boards, class_name: 'Shogi::Board', inverse_of: :game
  belongs_to :black, class_name: 'Shogi::Player', inverse_of: 'boards_black'
  belongs_to :white, class_name: 'Shogi::Player', inverse_of: 'boards_white'

  def length
    self.boards.count
  end

  def players
    result = []
    result << self.black if self.black
    result << self.white if self.white
    result
  end
end
