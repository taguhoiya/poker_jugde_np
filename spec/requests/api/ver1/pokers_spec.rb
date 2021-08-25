require 'rails_helper'
require "json"

# 1 受信したリクエストに対して適切なレスポンスを返す
#   リクエストに対してHTTPレスポンスがステータスコード200を返す。とか。
# 2 ビューで使用するのに必要なモデルオブジェクトをロードする
#   リクエストされたURLから必要なモデルインスタンスをロードしておく。とか。
# 3 レスポンスを表示するのに適切なビューを選択する
#   適切なテンプレートを表示している。とか。

RSpec.describe "PokersAPI", type: :request do
    let(:request_header) do
        { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    describe "get :check" do
        it 'return warnings' do
            get '/api/v1/cards/check'
            json = JSON.parse(response.body)
            expect(response.status).to eq(401)
            expect(json['error']).to eq "Unauthorized! Invalid token."
        end
    end
    describe "post :check" do
        subject do
            post "/api/v1/cards/check", cards, request_header
        end
        context "Running normally" do
            it 'Return the accurate JSON' do
                @json_params = { "cards": [ "D4 S13 D13 S3 H3", "H9 C9 S9 H5 C2", "C13 H13 S13 D13 D5" ] }.to_json
                post '/api/v1/cards/check', params: @json_params, headers: request_header
                json = JSON.parse(response.body)
                expect(response.status).to eq(201)
                expect(json['result']).to eq [{"card"=>"D4 S13 D13 S3 H3","hand"=>"ツーペア","best"=>"false"},{"card"=>"H9 C9 S9 H5 C2","hand"=>"スリーカード","best"=>"false"},{"card"=>"C13 H13 S13 D13 D5","hand"=>"フォーカード","best"=>"true"}]
            end
        end
    end
end