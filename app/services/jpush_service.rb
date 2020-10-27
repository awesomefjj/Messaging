class JpushService
  def initialize(event_id)
    @pusher = JPush::Client.new(ENV['JPUSH_APP_KEY'], ENV['JPUSH_APP_SECRET']).pusher
    @audience = JPush::Push::Audience.new
    @event = Tmdomain::Notifications.find_event(event_id)
  end

  def push_notification(audience_setting)
    set_audience(audience_setting)
    notification = JPush::Push::Notification.new.
                  set_android(
                    alert: @event.content.to_s,
                    title: @event.title,
                    alert_type: 1 | 2 | 4, # 表示通知提醒方式， 可选范围为 -1～7 
                    extras: @event.extra_data
                  ).set_ios(
                    alert: "#{@event.title}\n#{@event.content.to_s}",
                    extras: @event.extra_data
                  )
    # apns_production: True 表示推送生产环境，False 表示要推送开发环境;
    return if audience_setting[:all_user].blank? && @audience.to_hash.blank?

    push_payload = JPush::Push::PushPayload.new(
      platform: 'all',
      audience: audience_setting[:all_user] ? 'all' : @audience,
      notification: notification
    ).set_options(apns_production: Rails.env.production?)
    @pusher.push(push_payload)
  end

  def set_audience(options)
    options = options.symbolize_keys.slice(:tag, :tag_and, :tag_not, :alias, :registration_id, :segment, :abtest)
    options.each_pair do |k, v|
      @audience.send("set_#{k}", v) if v.present?
    end
  end
end