require "rails_helper"
require "json"

# 1 受信したリクエストに対して適切なレスポンスを返す
#   リクエストに対してHTTPレスポンスがステータスコード200を返す。とか。
# 2 ビューで使用するのに必要なモデルオブジェクトをロードする
#   リクエストされたURLから必要なモデルインスタンスをロードしておく。とか。
# 3 レスポンスを表示するのに適切なビューを選択する
#   適切なテンプレートを表示している。とか。

RSpec.describe "PokersAPI", type: :request do
  let(:request_header) do
    { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
  end
  let(:json) { JSON.parse(response.body) }

  describe "get :check" do
    it "return warnings" do
      get "/api/v1/cards/check"
      expect(response.status).to eq(404)
      expect(json["error"]).to eq "不正なURLです。"
    end
  end

  describe "post :check" do
    context "when running normally" do
      it "Return the accurate JSON" do
        @json_params = { "cards": ["D4 S13 D13 S3 H3", "H9 C9 S9 H5 C2", "C13 H13 S13 D13 D5"] }.to_json
        post "/api/v1/cards/check", params: @json_params, headers: request_header
        expect(response.status).to eq(201)
        expect(json["result"]).to eq [
          { "card" => "D4 S13 D13 S3 H3", "hand" => "ツーペア", "best" => "false" },
          { "card" => "H9 C9 S9 H5 C2", "hand" => "スリーカード", "best" => "false" },
          { "card" => "C13 H13 S13 D13 D5", "hand" => "フォーカード", "best" => "true" }
        ]
      end
    end

    context "when there is sth wrong" do
      context "when URL is wrong" do
        it "Return the error JSON(/api/v1)" do
          @json_params = { "cards": ["C7 S13 C8 S3 H4", "H9 C9 S9 H13 C2", "C13 H13 S13 D13 D2"] }.to_json
          post "/api/v1", params: @json_params, headers: request_header
          expect(response.status).to eq(404)
          expect(json["error"]).to eq "不正なURLです。"
        end

        it "Return the error JSON(/api/v1/card) " do
          @json_params = { "cards": ["C7 S13 C8 S3 H4", "H9 C9 S9 H13 C2", "C13 H13 S13 D13 D2"] }.to_json
          post "/api/v1/card", params: @json_params, headers: request_header
          expect(response.status).to eq(404)
          expect(json["error"]).to eq "不正なURLです。"
        end
      end

      context "when cards are invalid (pattern 1) " do
        it "Return the accurate JSON" do
          @json_params = { "cards": [" D4 S13 D13 S3 H4 ", "H9 C9 S9 R5 C2", "C13 H13 S13 D13 D5 D2"] }.to_json
          post "/api/v1/cards/check", params: @json_params, headers: request_header
          expect(response.status).to eq(201)
          expect(json["result"]).to eq [
            { "card" => " D4 S13 D13 S3 H4 ", "error" => "先頭にも末尾にもスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）" },
            { "card" => "H9 C9 S9 R5 C2", "error" => "4番目のカード指定文字が不正です。（R5)" },
            { "card" => "C13 H13 S13 D13 D5 D2", "error" => "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）" }
          ]
        end
      end

      context "when cards are invalid (pattern 2)" do
        it "Return the accurate JSON" do
          @json_params = { "cards": [" S13 D13 S3 H3", "R9   S9R5 C", ""] }.to_json
          post "/api/v1/cards/check", params: @json_params, headers: request_header
          expect(response.status).to eq(201)
          expect(json["result"]).to eq [
            {
              "card" => " S13 D13 S3 H3",
              "error" => "先頭にスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
            },
            {
              "card" => "R9   S9R5 C",
              "error" => "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
            },
            {
              "card" => "R9   S9R5 C",
              "error" => "1番目のカード指定文字が不正です。（R9)"
            },
            {
              "card" => "R9   S9R5 C",
              "error" => "2番目のカード指定文字が不正です。（S9R5)"
            },
            {
              "card" => "R9   S9R5 C",
              "error" => "3番目のカード指定文字が不正です。（C)"
            },
            {
              "card" => "",
              "error" => "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
            }
          ]
        end
      end
    end
  end
end
