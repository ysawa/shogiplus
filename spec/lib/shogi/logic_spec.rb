# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../spec_helper'

describe Shogi::Logic do
  describe 'reverse_role' do
    it 'moves correctly' do
      Shogi::Logic.reverse_role('fu').should == 'tokin'
      Shogi::Logic.reverse_role('tokin').should == 'fu'
      Shogi::Logic.reverse_role('kaku').should == 'ryuma'
      Shogi::Logic.reverse_role('ryuma').should == 'kaku'
      Shogi::Logic.reverse_role('hisha').should == 'ryuou'
      Shogi::Logic.reverse_role('ryuou').should == 'hisha'
      Shogi::Logic.reverse_role('gin').should == 'narigin'
      Shogi::Logic.reverse_role('narigin').should == 'gin'
      Shogi::Logic.reverse_role('keima').should == 'narikei'
      Shogi::Logic.reverse_role('narikei').should == 'keima'
      Shogi::Logic.reverse_role('kyosha').should == 'narikyo'
      Shogi::Logic.reverse_role('narikyo').should == 'kyosha'
    end

    it 'cannot reverse ou or kin' do
      %w(ou kin).each do |role|
        begin
          Shogi::Logic.reverse_role(role)
        rescue
          next
        end
        raise
      end
    end
  end
end
