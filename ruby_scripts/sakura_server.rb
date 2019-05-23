#!/usr/bin/env ruby

class SakuraServer

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
  end

  # server.createに対応
  # 引数があると、オブジェクトの状態を変えつつそちらを使う
  def create(server_params)
  end

  private

  # createとdestroyで独自に引数を取れるようにしておく
  def init_instance_variable(params)

  end
end


# main

# sakuraserverのインスタンスを作成し、createする流れ
# おそらくclassの部分は切り貼りし、mainは実際には使わないのでテスト実装

sakura =  SakuraServer.new(zone: 5, tags:"test")

#sakura.create() <- createする際はこれを呼び出す

