class PokersController < ApplicationController
  require_relative "../services/judge"
  require_relative "../services/validation"

  def index; end

  def create
    @valid = Validation.new
    @input_warn = @valid.validate_input(params)
    @suit_warn = @valid.validate_suit(params)

    @judgehand = JudgeHand.new
    @show_hand = @judgehand.judge_hand(params)
    render :index
  end
end
