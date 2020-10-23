class AppPushWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(event_id, registration_ids)
    @registration_ids = registration_ids
    @event = Tmdomain::Notifications.find_event(event_id)
    push_message_to_app! if @registration_ids.present?
  end

  private

  def push_message_to_app!
    JpushService.new.push_notification(@registration_ids, @event.content.to_s, @event.title, @event.extra_data)
  end
end
