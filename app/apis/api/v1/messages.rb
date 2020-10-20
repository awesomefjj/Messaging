class API::V1::Messages < Grape::API
  resources :messages do
    desc '创建消息'
    params do
      requires :receiver_type, type: String, desc: '接收方类型'
      requires :receiver_ids, type: Array[Integer], desc: '接收方的ID'
      requires :title, type: String, desc: '标题'
      requires :kind, type: Integer, desc: '消息类型'
      optional :content, type: String, desc: '正文内容'
      optional :tenant_id, type: String, desc: '站点id'
      optional :redirect_url, type: String, desc: '消息地址'
      optional :extra_data, type: JSON, desc: '其他数据'
    end
    post do
      event_params = params.slice(:kind, :title, :content, :redirect_url, :extra_data)
      service = SendToReceiversService.new(**event_params.symbolize_keys)
      service.receiver_to(params[:receiver_type], params[:receiver_ids])
      success!
    end
  end
end
