class API::V1::Messages < Grape::API
  helpers API::CommonHelpers
  resources :messages do
    desc '创建消息'
    params do
      requires :receiver_type, type: String, desc: '接收方类型'
      requires :receiver_ids, type: Array[Integer], desc: '接收方的ID'
      requires :title, type: String, desc: '标题'
      requires :kind, type: Integer, desc: '消息类型(normal broadcast warning system)'
      optional :content, type: String, desc: '正文内容'
      optional :tenant_id, type: String, desc: '站点id'
      optional :redirect_url, type: String, desc: '消息地址'
      optional :extra_data, type: JSON, desc: '其他数据'
      optional :tenant_id, type: String, desc: '站点ID（暂时不用该属性）'
    end
    post do
      event_params = params.slice(:kind, :title, :content, :redirect_url, :extra_data)
      service = SendToReceiversService.new(**event_params.symbolize_keys)
      service.receiver_to(params[:receiver_type], params[:receiver_ids])
      success!
    end

    desc '获取消息'
    params do
      requires :receiver_type, type: String, desc: '接收方类型'
      requires :receiver_id, type: Integer, desc: '接收方的ID'
      optional :status, type: Array[Integer], desc: '消息状态(unread, read, deleted)'
      optional :kind, type: Integer, desc: '消息类型(normal broadcast warning system)'
      optional :tenant_id, type: String, desc: '站点ID（暂时不用该属性）'
      optional :page, type: Integer, desc: '需要显示的页码'
      optional :page_size, type: Integer, desc: '每页显示数量, 默认20'
    end

    get do
      message_params = params.slice(:receiver_type, :receiver_id, :status, :kind, :tenant_id, :page, :page_size)
      query = Tmdomain::Notifications.notifications_of(**message_params.symbolize_keys)
      success! query, with: API::Entities::Message
    end
  end
end
