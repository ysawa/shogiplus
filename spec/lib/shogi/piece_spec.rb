# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../spec_helper'

describe Shogi::Piece do
  before :each do
    @piece = Shogi::Piece.new position: [5, 1], role: 'ou', black: false
  end

  it 'can be initialized' do
    @piece.x.should == 5
    @piece.y.should == 1
    @piece.role.should == 'ou'
    @piece.black.should be_false
  end
end
