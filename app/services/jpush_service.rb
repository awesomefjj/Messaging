class JpushService
  def initialize
    @pusher = JPush::Client.new(ENV['JPUSH_APP_KEY'], ENV['JPUSH_APP_SECRET']).pusher
  end

  # @param [Array] registration_ids 推送给谁,nil时表示推送给所有人
  # @param [String] alert 通知的内容
  # @param [String] title 通知标题
  # @param [JSON] extras 扩展字段，接受一个 Hash 对象，以供业务使用
  def push_notification(registration_ids, alert, title, extras)
    if registration_ids
      audience = JPush::Push::Audience.new
      audience.set_registration_id(registration_ids)
    end

    notification = JPush::Push::Notification.new.
                  set_android(
                    #表示通知内容，会覆盖上级统一指定的 alert; 内容可以为空字符串，表示不展示到通知栏(android)
                    alert: alert,
                    # 表示通知标题，会替换通知里原来展示 App 名称的地方
                    title: title,
                    # 表示通知提醒方式， 可选范围为 -1～7 ，
                    # 对应 Notification.DEFAULT_ALL = -1
                    # 或者 Notification.DEFAULT_SOUND = 1， Notification.DEFAULT_VIBRATE = 2， Notification.DEFAULT_LIGHTS = 4 的任意 “or” 组合。
                    # 默认按照 -1 处理。
                    alert_type: 1 | 2 | 4,
                    extras: extras
                  ).set_ios(
                    alert: "#{title}\n#{alert}",
                    extras: extras
                  )
    # apns_production: True 表示推送生产环境，False 表示要推送开发环境;
    push_payload = JPush::Push::PushPayload.new(
      platform: 'all',
      audience: audience || 'all',
      notification: notification
    ).set_options(apns_production: Rails.env.production?)

    @pusher.push(push_payload)
  end

end
