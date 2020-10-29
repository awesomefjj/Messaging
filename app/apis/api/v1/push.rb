class API::V1::Push < Grape::API
  helpers API::CommonHelpers
  resources :push do
    desc '推送至app'
    params do
      requires :event_id, type: Integer, desc: '消息事件ID'
      optional :all_user, type: Boolean, desc: '广播（推送给所有人）'
      optional :tag, type: Array[String], desc: '多个标签之间是 OR 的关系，即取并集'
      optional :tag_and, type: Array[String], desc: '多个标签之间是 AND 关系，即取交集'
      optional :tag_not, type: Array[String], desc: '多个标签之间，先取多标签的并集，再对该结果取补集'
      optional :alias, type: Array[String], desc: '多个别名之间是 OR 关系，即取并集'
      optional :registration_id, type: Array[String], desc: '多个注册 ID 之间是 OR 关系，即取并集'
      optional :segment, type: Array[String], desc: '在页面创建的用户分群的 ID(目前限制一次只能推送一个)'
      optional :abtest, type: Array[String], desc: '在页面创建的 A/B 测试的 ID(目前限制一次只能推送一个)'
    end
    post :app do
      AppPushWorker.perform_async(params[:event_id], params)
      success!
    end
  end
end
