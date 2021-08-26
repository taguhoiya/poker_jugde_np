module API
  module Ver1
    class Root < Grape::API
      # http://localhost:3000/api/v1/
      version "v1", using: :path
      format :json

      route :any, "*path" do
        error! "不正なURLです。", 404
      end

      mount API::Ver1::Cards
    end
  end
end
