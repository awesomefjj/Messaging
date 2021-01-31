class API::Root < Grape::API
  format :json
  prefix :api
  rescue_from ActiveRecord::RecordNotFound, -> (_e) { not_found! }

  # 为app老版本建立v2，后面就删除掉并更新切换至v1中
  mount API::V1::Root
  mount API::V2::Root

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
      { name: 'push', description: '推送消息事件至第三方平台' },
    ]
end
