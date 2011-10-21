# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../spec_helper'

describe Shogi::Board, 'arranged' do
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
end
