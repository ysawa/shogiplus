# -*- coding: utf-8 -*-

# 9 8 7 6 5 4 3 2 1
# 香桂銀金玉金銀桂香 1
#   飛          馬   2
# 歩歩歩歩歩歩歩歩歩 3
#                    4
#                    5
#                    6
# 歩歩歩歩歩歩歩歩歩 7
#   馬          飛   8
# 香桂銀金王金銀桂香 9

module Shogi::Logic
  ROLES = %w(fu gin keima kyosha kaku hisha tokin narigin narikei narikyo ryuma ryuou kin ou)
  TOP_ROLES = %w(fu gin keima kyosha kaku hisha kin ou)
  BOTTOM_ROLES = %w(tokin narigin narikei narikyo ryuma ryuou)

  def bottom_role?(role)
    BOTTOM_ROLES.include? role
  end

  def can_move?(role, move_x, move_y, black)
    unless role? role
      raise ::Shogi::UnknownRole
    end
    send "#{role.to_s}_can_move?", move_x, move_y, black
  end

  def fu_can_move?(move_x, move_y, black)
    return false if move_x == 0 and move_y == 0
    if black
      move_y *= -1
    end
    if move_x == 0 and move_y == 1
      true
    else
      false
    end
  end

  def gin_can_move?(move_x, move_y, black)
    return false if move_x == 0 and move_y == 0
    if black
      move_y *= -1
    end
    if move_x.abs <= 1 and move_y.abs <= 1 and
        !(move_x.abs == 1 and move_y == 0) and
        !(move_x == 0 and move_y == -1)
      true
    else
      false
    end
  end

  def hisha_can_move?(move_x, move_y, black)
    return false if move_x == 0 and move_y == 0
    if move_x == 0 or move_y == 0
      true
    else
      false
    end
  end

  def kaku_can_move?(move_x, move_y, black)
    return false if move_x == 0 and move_y == 0
    if move_x.abs == move_y.abs
      true
    else
      false
    end
  end

  def keima_can_move?(move_x, move_y, black)
    if black
      move_y *= -1
    end
    if move_x.abs == 1 and move_y == 2
      true
    else
      false
    end
  end

  def kin_can_move?(move_x, move_y, black)
    return false if move_x == 0 and move_y == 0
    if black
      move_y *= -1
    end
    if move_x.abs <= 1 and move_y.abs <= 1 and
        !(move_x.abs == 1 and move_y == -1)
      true
    else
      false
    end
  end

  def kyosha_can_move?(move_x, move_y, black)
    if black
      move_y *= -1
    end
    if move_x == 0 and move_y > 0
      true
    else
      false
    end
  end

  def narigin_can_move?(move_x, move_y, black)
    kin_can_move?(move_x, move_y, black)
  end

  def narikei_can_move?(move_x, move_y, black)
    kin_can_move?(move_x, move_y, black)
  end

  def narikyo_can_move?(move_x, move_y, black)
    kin_can_move?(move_x, move_y, black)
  end

  def ou_can_move?(move_x, move_y, black)
    return false if move_x == 0 and move_y == 0
    if move_x.abs <= 1 and move_y.abs <= 1
      true
    else
      false
    end
  end

  def reverse_role(role)
    if top_role? role and !(role == 'ou' or role == 'kin')
      key = TOP_ROLES.index role
      BOTTOM_ROLES[key]
    elsif bottom_role? role
      key = BOTTOM_ROLES.index role
      TOP_ROLES[key]
    else
      raise Shogi::UnexpectedReverse
    end
  end

  def role?(role)
    ROLES.include? role.to_s
  end

  def ryuma_can_move?(move_x, move_y, black)
    return false if move_x == 0 and move_y == 0
    if move_x.abs == move_y.abs or (move_x.abs <= 1 and move_y.abs <= 1)
      true
    else
      false
    end
  end

  def ryuou_can_move?(move_x, move_y, black)
    return false if move_x == 0 and move_y == 0
    if (move_x == 0 or move_y == 0) or (move_x.abs <= 1 and move_y.abs <= 1)
      true
    else
      false
    end
  end

  def tokin_can_move?(move_x, move_y, black)
    kin_can_move?(move_x, move_y, black)
  end

  def top_role?(role)
    TOP_ROLES.include? role
  end

  module_function :can_move?, :role?
  module_function :fu_can_move?, :gin_can_move?, :hisha_can_move?, :kaku_can_move?
  module_function :keima_can_move?, :kin_can_move?, :kyosha_can_move?
  module_function :narigin_can_move?, :narikei_can_move?, :narikyo_can_move?, :ou_can_move?
  module_function :ryuma_can_move?, :ryuou_can_move?, :tokin_can_move?
  module_function :reverse_role, :bottom_role?, :top_role?
end
