# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'

describe Shogi::Game do
  before :each do
    @game = Shogi::Game.new
  end

  it 'can be initialized' do
    @game.length.should == 0
  end
end
