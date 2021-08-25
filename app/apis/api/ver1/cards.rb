module API
    module Ver1
      class Cards < Grape::API
        require_relative "../../../services/validation.rb"
        require_relative "../../../services/judge_api.rb"
        require_relative "../../../services/judge.rb"
        require 'json'
        resource :cards do
            format :json
            # GET /api/v1/cards/check
            desc 'Return warnings'
            get ':check' do
                error!("Unauthorized! Invalid token.", 401)
            end
            
            desc "Return the accurate JSON"
            post ":check" do
                @body = env['api.request.body']["cards"]
                @worth = []
                @worth_bool = []
                @show_hand = []
                @input_warn = []
                @suit_warn = []
                @result = []
                @hash = {}

                @body.each.with_index do |b, i|
                    params = {"array": @body[i]}
                    @worth << JudgeHand.judge_hand_api(params)
                    @show_hand << JudgeHand.judge_hand(params)
                    @input_warn << Validation.validate_input(params)
                    @suit_warn << Validation.validate_suit(params)
                end

                @worth_s = @worth.map!{|w| w.to_s}
                @worth_bool = @worth_s.map{|w| w.gsub(/#{@worth.min.to_s}/, "true").gsub(/[1-9]/, "false")}

                @body.each.with_index do |b, i|
                    if  @input_warn[i].present?
                        @result << { "card" => b , "error" => @input_warn[i] }
                    elsif @suit_warn[i].present?
                        @result << { "card" => b , "error" => "#{@suit_warn[i].flatten[0]}番目のカード指定文字が不正です。（#{@suit_warn[i].flatten[1]})" }
                    else
                        @result << { "card" => b , "hand" => @show_hand[i], "best" => @worth_bool[i] }
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