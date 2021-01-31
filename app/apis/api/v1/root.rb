class API::V1::Root < Grape::API
  version 'v1', using: :path
  mount API::V1::Messages
end
