module API
  module Ver1
    class Cards < Grape::API
      require_relative "../../../services/validation"
      require_relative "../../../services/judge_api"
      require_relative "../../../services/judge"

      # routing error "api/v1/~~"
      route :any, "*path" do
        error! "不正なURLです。", 404
      end

      require "json"
      require "active_support"
      require "active_support/core_ext"

      resource :cards do
        format :json

        # routing error "api/v1/cards/~~"
        desc "Return warnings"
        get ":check" do
          error! "不正なURLです。", 404
        end

        desc "Return the accurate JSON"
        post ":check" do
          # cardsというkeyが指定されているかどうか
          unless params.first[0].include?("cards")
            error! "先頭に”cards”というキーを指定してください。（例 : { ”cards”: [ ”H1 H13 H12 H11 H10”, ”H9 C9 S9 H2 C2”, ”C13 D12 C11 H8 H7” ]}）", 404
          end

          @body = params.first[1]
          @worth = []
          @worth_bool = []
          @show_hand = []
          @input_warn = []
          @suit_warn = []
          @result = []
          @hash = {}

          # individual validations & judging hands
          @body.each.with_index do |b, i|
            params = { "array": @body[i] }
            @judgehand = JudgeHand.new
            @show_hand << @judgehand.judge_hand(params)

            @judgeapi = JudgeHandApi.new
            @worth << @judgeapi.judge_hand_api(params)

            @valid = Validation.new
            @input_warn << @valid.validate_input(params)
            @suit_warn << @valid.validate_suit(params)
          end

          @worth_s = @worth.map!(&:to_s)
          @worth_bool = @worth_s.map { |w| w.gsub(/#{@worth.min}/, "true").gsub(/[1-9]/, "false") }

          # nests for outputs
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
