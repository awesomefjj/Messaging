Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get :_healthz, to: ->(_req) {
    # 检查 redis
    Redis.current.get('healthz')
    # 检查数据库版本
    ActiveRecord::Migration.check_pending!
    [200, {}, ["OK\n"]]
  }

  mount API::Root => '/'
  mount GrapeSwaggerRails::Engine => '/api/tm-docs'
end
