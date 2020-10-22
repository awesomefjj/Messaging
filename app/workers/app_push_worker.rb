class AppPushWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(event_id, receiver_ids)
    # Do something later
    @receiver_ids = receiver_ids
    @event = Tmdomain::Notifications.find_event(event_id)
    set_registration_ids
    push_message_to_app! if @registration_ids.present?
  end

  private

  attr_reader :event, :receiver_ids

  def push_message_to_app!
    content = event.content || ''
    JpushService.new.push_notification(@registration_ids, content, event.title, event.extra_data)
  end

  def set_registration_ids
    service = TamigosApiService.new
    user_infos = service.get_users_info(receiver_ids)
    @registration_ids = user_infos.map { |info| info['jpush_registration_id'] }.compact.uniq
  end
end
