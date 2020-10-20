class SendToReceiversService
  def initialize(kind:, title:, content: nil, redirect_url: nil, extra_data: nil)
    @event_params = {
      kind: kind,
      title: title,
      content: content,
      redirect_url: redirect_url,
      extra_data: extra_data
    }
    @event = Tmdomain::Notifications.create_event(@event_params)
  end

  def receiver_to(receiver_type, receiver_ids)
    receiver_ids.each do |receiver_id|
      send_to_receiver(receiver_type, receiver_id)
    end
  end
  private

  attr_reader :event_params, :event, :tenant_id

  def send_to_receiver(receiver_type, receiver_id, tenant_id = nil)
    Tmdomain::Notifications.notify(
      tenant_id,
      receiver_type,
      receiver_id,
      kind: event.kind,
      title: event.title,
      redirect_url: event.redirect_url,
      content: event.content,
      event_id: event.id
    )
  end
end