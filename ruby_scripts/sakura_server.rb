#!/usr/bin/env ruby

class SakuraServer

  require 'httpclient'

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
      
      send_request('get', '', '')
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

