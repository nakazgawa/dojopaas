#!/usr/bin/env ruby

class SakuraServer

  require 'httpclient'

  SAKURA_BASE_URL     = 'https://secure.sakura.ad.jp/cloud/zone'
  SAKURA_ZONE_ID      = 'is1b'
  SAKURA_CLOUD_SUFFIX = 'api/cloud'
  SAKURA_API_VERSION  = '1.1'

  SAKURA_TOKEN        = ENV['SAKURA_TOKEN'].fetch
  SAKURA_TOKEN_SECRET = ENV['SAKURA_TOKEN_SECRET'].fetch

  # jsのserver.createで使っているフィールドを参考
  def initialize(zone:0, plan:nil, packetfilterid:nil, name:nil, description:nil, tags:nil, pubkey:nil, disk:nil, resolve:nil, notes:nil)
    @zone           = zone
    @plan           = plan
    @packetfilterid = packetfilterid
    @name           = name
    @description    = description
    @tags           = tags
    @pubkey         = pubkey
    @disk           = disk
    @resolve        = resolve
    @notes          = notes

    @client = HTTPClient.new
  end

  # server.createに対応
  # 引数があると、オブジェクトの状態を変えつつそちらを使う
  def create(server_params)

  end

  private

  # createとdestroyで独自に引数を取れるようにしておく
  def init_instance_variable(params)

    #インスタンス作成
    puts "Create a server for #{@name}."

    params = {
      :Zone => @zone, :ServerPlan => @plan, :Name => @name, 
      :Description => @description, :Tags => @tags
    }

    send_request('post', 'server', create_endpoint('server'), params)

  end


  def send_request(http_method,endpoint,query)
    @client.send(lc(http_method),endpoint,query)
  end
  #def check_parameters
  #end
end


# main

# sakuraserverのインスタンスを作成し、createする流れ
# おそらくclassの部分は切り貼りし、mainは実際には使わないのでテスト実装

sakura =  SakuraServer.new(zone: 5, tags:"test")

#sakura.create() <- createする際はこれを呼び出す

