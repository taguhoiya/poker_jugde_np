class PokerController < ApplicationController
  def index
  end

  def create
    Validation.validate_form(params)
    Validation.validate_suit(params)
    Judge_hand.judge_hand(params)
  end
end
