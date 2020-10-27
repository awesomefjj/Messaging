class API::Root < Grape::API
  format :json

  prefix :api
  mount API::V1::Root
  mount API::V1::Messages
  mount API::V1::PushPlatform
  # 健康检查
  get :healthz do
    'OK'
  end

  add_swagger_documentation \
    info: {
      title: "TMF API",
      # description: "",
      # contact_name: "Xiaohui",
      # contact_email: "xiaohui@tanmer.com",
    },
    tags: [
      { name: 'healthz', description: '健康检查' },
      { name: 'messages', description: '消息' },
      { name: 'push_platform', description: '推送消息事件至第三方平台' },
    ]
end
