class AppPushWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(event_id, options)
    @event = Tmdomain::Notifications.find_event(event_id)
    push_message_to_app!(options) if options.present?
  end

  private

  def push_message_to_app!(options)
    JpushService.new(@event.id).push_notification(options.symbolize_keys)
  end
end
