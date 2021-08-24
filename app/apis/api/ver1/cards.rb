module API
    module Ver1
      class Cards < Grape::API
        require_relative "../../../services/judge_api.rb"
        require_relative "../../../services/judge.rb"
        require 'json'
        resource :cards do
            format :json
            # GET /api/v1/cards/check
            desc 'Return a product.'
            get ':check' do
                error!("Unauthorized! Invalid token.", 401)
            end
            post ":check" do
                @body = env['api.request.body']["cards"]
                @worth = []
                @worth_bool = []
                @show_hand = []
                @result = []
                @hash = {}

                @body.each.with_index do |b, i|
                    params = {"array": @body[i]}
                    @show_hand << JudgeHand.judge_hand(params)
                    @worth << JudgeHand.judge_hand_api(params)
                end

                @worth_s = @worth.map!{|w| w.to_s}
                @worth_bool = @worth_s.map{|w| w.gsub(/#{@worth.min.to_s}/, "true").gsub(/[1-9]/, "false")}

                @body.each.with_index do |b, i|
                    @result << { "card" => b , "hand" => @show_hand[i], "best" => @worth_bool[i] }
                end

                @hash["result"] = @result               
                @body = @hash
                return @body
            end
        end
      end
    end
end