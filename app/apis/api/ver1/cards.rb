module API
  module Ver1
    class Cards < Grape::API
      require_relative "../../../services/validation"
      require_relative "../../../services/judge_api"
      require_relative "../../../services/judge"

      route :any, "*path" do
        error! "不正なURLです。", 404
      end

      require "json"
      resource :cards do
        format :json

        desc "Return warnings"
        get ":check" do
          error! "不正なURLです。", 404
        end

        desc "Return the accurate JSON"
        post ":check" do
          @body = params["cards"]
          @worth = []
          @worth_bool = []
          @show_hand = []
          @input_warn = []
          @suit_warn = []
          @result = []
          @hash = {}

          @body.each.with_index do |b, i|
            params = { "array": @body[i] }
            @worth << JudgeHand.judge_hand_api(params)
            @show_hand << JudgeHand.judge_hand(params)
            @input_warn << Validation.validate_input(params)
            @suit_warn << Validation.validate_suit(params)
          end

          @worth_s = @worth.map!(&:to_s)
          @worth_bool = @worth_s.map { |w| w.gsub(/#{@worth.min}/, "true").gsub(/[1-9]/, "false") }

          @body.each.with_index do |b, i|
            if @input_warn[i].present?
              @result << { "card" => b, "error" => @input_warn[i] }
            end
            if @suit_warn[i].present?
              @s_w = @suit_warn.select(&:present?)
              @s_w = @s_w.flatten.each_slice(2).to_a
              @s_w.each do |s|
                @result << { "card" => b, "error" => "#{s[0]}番目のカード指定文字が不正です。（#{s[1]})" }
              end
            end

            if @input_warn[i].blank? && @suit_warn[i].blank?
              @result << { "card" => b, "hand" => @show_hand[i], "best" => @worth_bool[i] }
            end
          end

          @hash["result"] = @result
          @body = @hash
          return @body
        end
      end
    end
  end
end
