Tmdomain::Notifications.configure do |config|
  config.base_active_record = ApplicationRecord
  # 暂时只考虑以下集中类型的消息
  config.kinds = %i[normal broadcast warning system]
end

Tmdomain::Notifications::Event.class_eval do
  belongs_to :app
end