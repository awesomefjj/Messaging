# 从 api 获取用户信息
class TamigosApiService
  def initialize(host: ENV.fetch('TAMIGOS_API_HOST'))
    @host = host
  end

  def get_users_info(user_ids)
    params = {
      _where: {
        user_id: user_ids
      }
    }
    result = JSON.parse client.get('/v1/members', params).body
    result['code'] == 0 ? result.dig('message', 'items') : []
  end

  private

  def client
    @client ||= Faraday.new(url: @host) do |conn|
      conn.headers['Content-Type'] = 'application/json'
      conn.headers['User-Agent'] = 'Baklib API Client'
      conn.adapter :net_http
    end
  end
end