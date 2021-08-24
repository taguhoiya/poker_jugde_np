module API
    class Root < Grape::API
      # http://localhost:3000/api/
      prefix 'api'
      mount API::Ver1::Root
    end
end