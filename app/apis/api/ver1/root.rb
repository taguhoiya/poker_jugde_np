module API
    module Ver1
      class Root < Grape::API
        # http://localhost:3000/api/v1/
        version 'v1', using: :path
        format :json
  
        mount API::Ver1::Cards
        route :any, '*path' do
            error! I18n.t('grape.errors.not_found'), 404
          end
    
      end
    end
end