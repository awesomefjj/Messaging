class API::V1::Messages < Grape::API
  helpers API::CommonHelpers
  helpers API::SharedParams

  resources :messages do
    desc '获取消息列表'
    params do
    end
    get do
      success! [], with: API::Entities::Message
    end
  end
end
