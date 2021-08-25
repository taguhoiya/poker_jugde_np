module API
  class Root < Grape::API
    # http://localhost:3000/api/
    prefix "api"
    format :json
    route :any, "*path" do
      error! "不正なURLです。", 404
    end
    mount API::Ver1::Root
  end
end
