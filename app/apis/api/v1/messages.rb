class API::V1::Messages < Grape::API
  helpers API::CommonHelpers
  resources :messages do
    before do
      params[:receiver_type] = params[:receiver_type].classify if params[:receiver_type].present?
    end

    desc '创建消息'
    params do
      requires :receiver_type, type: String, desc: '接收方类型'
      requires :receiver_ids, type: Array[Integer], desc: '接收方的ID'
      requires :title, type: String, desc: '标题'
      requires :kind, type: Integer, desc: '消息类型(normal broadcast warning system)'
      optional :content, type: String, desc: '正文内容'
      optional :tenant_id, type: String, desc: '站点ID（暂时只有desk使用该属性）'
      optional :redirect_url, type: String, desc: '消息地址'
      optional :extra_data, type: JSON, desc: '其他数据'
      optional :registration_ids, type: Array[String], desc: '推送至APP的指定用户'
    end
    post do
      event_params = params.slice(:kind, :title, :content, :redirect_url, :extra_data)
      service = SendToReceiversService.new(**event_params.symbolize_keys)
      service.receiver_to(params[:receiver_type], params[:receiver_ids], params[:tenant_id])
      if params[:registration_ids].present?
        AppPushWorker.perform_async(service.event.id, params[:registration_ids])
      end
      success!
    end

    desc '获取消息列表'
    params do
      requires :receiver_type, type: String, desc: '接收方类型'
      requires :receiver_id, type: Integer, desc: '接收方的ID'
      optional :status, type: Array[Integer], desc: '消息状态(unread, read, deleted)'
      optional :kind, type: Integer, desc: '消息类型(normal broadcast warning system)'
      optional :tenant_id, type: String, desc: '站点ID（暂时只有desk使用该属性）'
      optional :page, type: Integer, desc: '需要显示的页码'
      optional :page_size, type: Integer, desc: '每页显示数量, 默认20'
    end
    get do
      message_params = params.slice(:receiver_type, :receiver_id, :status, :kind, :tenant_id, :page, :page_size)
      query = Tmdomain::Notifications.notifications_of(**message_params.symbolize_keys)
      success! query, with: API::Entities::Message
    end

    desc '读取所有消息'
    params do
      requires :receiver_type, type: String, desc: '接收方类型'
      requires :receiver_id, type: Integer, desc: '接收方的ID'
      optional :tenant_id, type: String, desc: '站点ID（暂时只有desk使用该属性）'
      optional :kind, type: Integer, desc: '消息类型(normal broadcast warning system)'
    end
    get :read_all do
      Tmdomain::Notifications.read_all(params[:tenant_id], params[:receiver_type], params[:receiver_id], kind: params[:kind])
      success!
    end

    desc '未读消息数'
    params do
      requires :receiver_type, type: String, desc: '接收方类型'
      requires :receiver_id, type: Integer, desc: '接收方的ID'
      optional :tenant_id, type: String, desc: '站点ID（暂时只有desk使用该属性）'
    end
    get :unreads do
      query = Tmdomain::Notifications.unreads(params[:receiver_type], params[:receiver_id], tenant_id: params[:tenant_id])
      success! query
    end

    desc '硬删除 N 天前的通知(软删除之后，才能硬删除)'
    params do
      requires :ndays, type: Integer, desc: '天数'
    end
    delete :cleanup do
      Tmdomain::Notifications.cleanup(params[:ndays])
      success!
    end

    namespace ':id' do
      desc '获取消息信息'
      get do
        query = Tmdomain::Notifications.find_by_id(params[:id])
        success! query, with: API::Entities::Message
      end

      desc '读取消息'
      get :read do
        query = Tmdomain::Notifications.read(params[:id])
        success! query, with: API::Entities::Message
      end

      desc '删除通知'
      delete do
        query = Tmdomain::Notifications.delete(params[:id])
        success! query, with: API::Entities::Message
      end
    end
  end
end
