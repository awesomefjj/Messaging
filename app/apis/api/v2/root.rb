class API::V2::Root < Grape::API
  version 'v2', using: :path
  mount API::V2::Messages
  mount API::V2::Push
end
