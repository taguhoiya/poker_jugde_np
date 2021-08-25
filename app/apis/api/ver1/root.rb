module API
  module Ver1
    class Root < Grape::API
      # http://localhost:3000/api/v1/
      version "v1", using: :path
      format :json

      route :any, "*path" do
        error! "不正なURLです。", 404
      end

      # 例外ハンドル 404
      rescue_from ActiveRecord::RecordNotFound do |e|
        rack_response({ message: e.message, status: 404 }.to_json, 404)
      end

      # 例外ハンドル 400
      rescue_from Grape::Exceptions::ValidationErrors do |e|
        rack_response e.to_json, 400
      end

      # 例外ハンドル 500
      rescue_from :all do |e|
        if Rails.env.development?
          raise e
        else
          error_response(message: "Internal server error", status: 500)
        end
      end

      mount API::Ver1::Cards
    end
  end
end
