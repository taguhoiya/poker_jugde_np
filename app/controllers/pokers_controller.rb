class PokersController < ApplicationController
  require_relative "../services/judge"
  require_relative "../services/validation"

  def index; end

  def create
    # variables for validations
    @valid = Validation.new
    @input_warn = @valid.validate_input(params)
    @suit_warn = @valid.validate_suit(params)

    # variables for judging hands
    @judgehand = JudgeHand.new
    @show_hand = @judgehand.judge_hand(params)
    render :index
  end
end
