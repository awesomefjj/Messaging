class ApplicationController < ActionController::Base
  def healthz
    # 检查 redis
    Redis.current.get('healthz')
    # 检查数据库版本
    ActiveRecord::Migration.check_pending!
    render plain: "OK\n", status: 200
  end
end
