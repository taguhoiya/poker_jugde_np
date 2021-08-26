require "rails_helper"

# 1 受信したリクエストに対して適切なレスポンスを返す
#   リクエストに対してHTTPレスポンスがステータスコード200を返す。とか。
# 2 ビューで使用するのに必要なモデルオブジェクトをロードする
#   リクエストされたURLから必要なモデルインスタンスをロードしておく。とか。
# 3 レスポンスを表示するのに適切なビューを選択する
#   適切なテンプレートを表示している。とか。

RSpec.describe "Pokers", type: :request do
  shared_examples "200 OK" do
    it "the request is to be 200 OK" do
      expect(response.status).to eq 200
    end
  end
  shared_examples "render index" do
    it "show the index template" do
      expect(response).to render_template :index
    end
  end
  shared_examples "@input_warn is nil" do
    it "@input_warn returns nil" do
      expect(@input_warn).to be_nil
    end
  end
  shared_examples "@suit_warn is empty" do
    it "@suit_warn returns empty" do
      expect(@suit_warn).to be_empty
    end
  end

  describe "GET #index" do
    before do
      get "/pokers"
    end

    it_behaves_like "200 OK"
    it_behaves_like "render index"
  end

  describe "POST #create" do
    context "when params is valid" do
      before do
        post "/pokers", params: params_array
        @input_warn = Validation.validate_input(params_array)
        @suit_warn = Validation.validate_suit(params_array)
        @show_hand = JudgeHand.judge_hand(params_array)
        @s_w = @suit_warn.map { |w| "#{w[0]}番目のカード指定文字が不正です。（#{w[1]}）" }
      end

      context "when royal straight flush" do
        let(:params_array) { { array: "S1 S11 S13 S10 S12" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it_behaves_like "@suit_warn is empty"
        it "show_hand is to be ロイヤルストレートフラッシュ" do
          expect(@show_hand).to eq "ロイヤルストレートフラッシュ"
        end
        it_behaves_like "render index"
      end

      context "when straight flush" do
        let(:params_array) { { array: "C6 C5 C3 C2 C4" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it_behaves_like "@suit_warn is empty"
        it "show_hand is to be ストレートフラッシュ" do
          expect(@show_hand).to eq "ストレートフラッシュ"
        end
        it_behaves_like "render index"
      end

      context "when four card" do
        let(:params_array) { { array: "H7 D7 C8 C7 S7" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it_behaves_like "@suit_warn is empty"
        it "show_hand is to be フォーカード" do
          expect(@show_hand).to eq "フォーカード"
        end
        it_behaves_like "render index"
      end

      context "when full house" do
        let(:params_array) { { array: "S4 H9 C4 H4 D9" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it_behaves_like "@suit_warn is empty"
        it "show_hand is to be フルハウス" do
          expect(@show_hand).to eq "フルハウス"
        end
        it_behaves_like "render index"
      end

      context "when straight" do
        let(:params_array) { { array: "S4 H7 C5 H6 D8" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it_behaves_like "@suit_warn is empty"
        it "show_hand is to be ストレート" do
          expect(@show_hand).to eq "ストレート"
        end
        it_behaves_like "render index"
      end

      context "when flush" do
        let(:params_array) { { array: "D4 D11 D5 D9 D8" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it_behaves_like "@suit_warn is empty"
        it "show_hand is to be フラッシュ" do
          expect(@show_hand).to eq "フラッシュ"
        end
        it_behaves_like "render index"
      end

      context "when three cards" do
        let(:params_array) { { array: "D4 H11 D11 S3 C11" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it_behaves_like "@suit_warn is empty"
        it "show_hand is to be スリーカード" do
          expect(@show_hand).to eq "スリーカード"
        end
        it_behaves_like "render index"
      end

      context "when two pairs" do
        let(:params_array) { { array: "D4 S13 D13 S3 H3" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it_behaves_like "@suit_warn is empty"
        it "show_hand is to be ツーペア" do
          expect(@show_hand).to eq "ツーペア"
        end
        it_behaves_like "render index"
      end

      context "when one pair" do
        let(:params_array) { { array: "D4 S7 C3 S1 C1" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it_behaves_like "@suit_warn is empty"
        it "show_hand is to be ワンペア" do
          expect(@show_hand).to eq "ワンペア"
        end
        it_behaves_like "render index"
      end

      context "when high card" do
        let(:params_array) { { array: "S1 H3 D9 C13 S11" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it_behaves_like "@suit_warn is empty"
        it "show_hand is to be ハイカード" do
          expect(@show_hand).to eq "ハイカード"
        end
        it_behaves_like "render index"
      end
    end

    context "when params is invalid" do
      before do
        post "/pokers", params: params_array
        @input_warn = Validation.validate_input(params_array)
        @suit_warn = Validation.validate_suit(params_array)
        @show_hand = JudgeHand.judge_hand(params_array)
        @s_w = @suit_warn.map { |w| "#{w[0]}番目のカード指定文字が不正です。（#{w[1]}）" }
      end

      context "when params is empty" do
        let(:params_array) { { array: "" } }

        it_behaves_like "200 OK"
        it "@input_warn is 5つのカード指定文字~" do
          expect(@input_warn).to eq "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
        end
        it_behaves_like "@suit_warn is empty"
      end

      context "when params is more than an expectation" do
        let(:params_array) { { array: "S1 H3 D9 C13 S11 D4" } }

        it_behaves_like "200 OK"
        it "@input_warn is 5つのカード指定文字~" do
          expect(@input_warn).to eq "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
        end
        it_behaves_like "@suit_warn is empty"
      end

      context "when params is duplicated" do
        let(:params_array) { { array: "S1 C13 D9 C13 S11" } }

        it_behaves_like "200 OK"
        it "@input_warn is カードが重複しています。" do
          expect(@input_warn).to eq "カードが重複しています。"
        end
        it_behaves_like "@suit_warn is empty"
      end

      context "when params has extra spaces" do
        let(:params_array) { { array: "S1   C13 D9  C13 S11" } }

        it_behaves_like "200 OK"
        it "@input_warn is 5つのカード指定文字~" do
          expect(@input_warn).to eq "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
        end
        it_behaves_like "@suit_warn is empty"
      end

      context "when params has extra spaces at the head" do
        let(:params_array) { { array: " S1 C13 D9 C13 S11" } }

        it_behaves_like "200 OK"
        it "@input_warn is 先頭に〜〜" do
          expect(@input_warn).to eq "先頭にスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
        end
        it_behaves_like "@suit_warn is empty"
      end

      context "when params has extra spaces at the end" do
        let(:params_array) { { array: "S1 C13 D9 C13 S11 " } }

        it_behaves_like "200 OK"
        it "@input_warn is 末尾に〜〜" do
          expect(@input_warn).to eq "末尾にスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
        end
        it_behaves_like "@suit_warn is empty"
      end

      context "when params has extra spaces both at the head and end" do
        let(:params_array) { { array: "   S1 C13 D9 C13 S11   " } }

        it_behaves_like "200 OK"
        it "@input_warn is 先頭にも末尾にも〜〜" do
          expect(@input_warn).to eq "先頭にも末尾にもスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
        end
        it_behaves_like "@suit_warn is empty"
      end

      context "when the first suit is invalid" do
        let(:params_array) { { array: "S107 C1 D9 C13 D5" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it "@suit_warn is 1番目のカード指定文字が不正です。（S107）" do
          expect(@s_w).to eq ["1番目のカード指定文字が不正です。（S107）"]
        end
      end

      context "when the multiple suits are invalid" do
        let(:params_array) { { array: "S107 C1555 D9 C138 D5" } }

        it_behaves_like "200 OK"
        it_behaves_like "@input_warn is nil"
        it "@suit_warn is 1番目のカード指定文字が不正です。（S107）~~" do
          expect(@s_w).to eq ["1番目のカード指定文字が不正です。（S107）", "2番目のカード指定文字が不正です。（C1555）", "4番目のカード指定文字が不正です。（C138）"]
        end
      end
    end
  end
end
