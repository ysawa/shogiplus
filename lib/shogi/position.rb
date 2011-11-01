# -*- coding: utf-8 -*-
#
class Shogi::Position < Array
  def +(position)
    Shogi::Position.new([x + position[0], y + position[1]])
  end

  def -(position)
    Shogi::Position.new([x - position[0], y - position[1]])
  end

  def relative_to(position)
    self - position
  end

  def x
    self[0]
  end

  def x=(x)
    self[0] = x
  end

  def y
    self[1]
  end

  def y=(y)
    self[1] = y
  end

  def on_board?
    (x >= 1) and (x <= 9) and (y >= 1) and (y <= 9)
  end

  def out_of_board?
    !on_board?
  end
end
