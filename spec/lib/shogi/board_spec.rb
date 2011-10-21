# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../spec_helper'

describe Shogi::Board do
  before :each do
    @board = Shogi::Board.arrange
  end

  it 'can be initialized' do
    @board.number.should == 0
  end

  it 'has black fu on [7, 7]' do
    piece = @board.find_piece_by_position [7, 7]
    piece.black.should be_true
    piece.role.should == 'fu'
  end

  it 'has white ou on [5, 1]' do
    piece = @board.find_piece_by_position [5, 1]
    piece.black.should be_false
    piece.role.should == 'ou'
  end

  it 'can be dumped' do
    @board.to_s.class.should be String
  end

  it 'has number to set proponent or opponent' do
    @board.number = 1
    @board.proponent.should == 'black'
    @board.opponent.should == 'white'
    @board.number = 2
    @board.proponent.should == 'white'
    @board.opponent.should == 'black'
  end

  it 'can be copied' do
    copy = @board.copy
    copy.number.should == @board.number + 1
    piece = @board.pieces.first
    copied_piece = copy.pieces.first
    copied_piece.id.should_not == piece.id
    copied_piece.position.should == piece.position
    copied_piece.role.should == piece.role
    copied_piece.black.should == piece.black
  end

  it 'can be copied and moved' do
    piece = @board.find_piece_by_position([7, 7])
    board_one = @board.copy_and_move(piece, [7, 6])
    moved_piece = board_one.find_piece_by_position([7, 6])
    moved_piece.role.should == piece.role
    moved_piece.black.should == piece.black
    moved_piece.position.should_not == piece.position
    puts board_one.to_s
    piece = board_one.find_piece_by_position([3, 3])
    board_two = board_one.copy_and_move(piece, [3, 4])
    moved_piece = board_two.find_piece_by_position([3, 4])
    moved_piece.role.should == piece.role
    moved_piece.black.should == piece.black
    moved_piece.position.should_not == piece.position
    puts board_two.to_s
    piece = board_two.find_piece_by_position([8, 8])
    board_three = board_two.copy_and_move(piece, [2, 2])
    moved_piece = board_three.find_piece_by_position([2, 2])
    moved_piece.role.should == piece.role
    moved_piece.black.should == piece.black
    moved_piece.position.should_not == piece.position
    puts board_three.to_s
    piece = board_three.find_piece_by_position([3, 1])
    board_four = board_three.copy_and_move(piece, [2, 2])
    moved_piece = board_four.find_piece_by_position([2, 2])
    moved_piece.role.should == piece.role
    moved_piece.black.should == piece.black
    moved_piece.position.should_not == piece.position
    puts board_four.to_s
  end
end
