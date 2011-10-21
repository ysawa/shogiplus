# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../spec_helper'

describe Shogi::Position do
  before :each do
    @position = Shogi::Position.new [5, 1]
  end

  it 'can be initialized' do
    @position.x.should == 5
    @position.y.should == 1
  end

  it 'can be estimated if out of board or not' do
    @position.on_board?.should be_true
    @position.out_of_board?.should be_false
    @position.x = 10
    @position.on_board?.should be_false
    @position.out_of_board?.should be_true
  end
end
