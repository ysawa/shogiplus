# -*- coding: utf-8 -*-

class Shogi::Player
  include Mongoid::Document
  include Mongoid::Timestamps
  field :first_name, type: String
  field :last_name, type: String
  field :name, type: String
  field :user_id, type: Integer
  has_many :games_black, class_name: 'Shogi::Game', inverse_of: :black
  has_many :games_white, class_name: 'Shogi::Game', inverse_of: :white

  def client=(client)
    @client = client
  end

  def user
    if @client
      @user ||= @client.get_graph(self.user_id)
    else
      raise
    end
  end

  def user=(user_graph)
    self.user_id = user_graph.id
    @user = user_graph
  end
end
