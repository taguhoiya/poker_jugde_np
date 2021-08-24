class PokersController < ApplicationController
  require_relative "../services/judge.rb"
  require_relative "../services/validation.rb"
  
  def index
  end


  def create
    
    @input_warn = Validation.validate_input(params)
    @suit_warn = Validation.validate_suit(params)
    @show_hand = JudgeHand.judge_hand(params)
    render :index
  end
end
