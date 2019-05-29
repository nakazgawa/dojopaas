#!/usr/bin/env ruby

class SakuraServer

  require 'jsonclient'

  SAKURA_BASE_URL     = 'https://secure.sakura.ad.jp/cloud/zone'
  SAKURA_ZONE_ID      = 'is1b'
  SAKURA_CLOUD_SUFFIX = 'api/cloud'
  SAKURA_API_VERSION  = '1.1'

  SAKURA_TOKEN        = ENV.fetch('SAKURA_TOKEN')
  SAKURA_TOKEN_SECRET = ENV.fetch('SAKURA_TOKEN_SECRET')

  # jsのserver.createで使っているフィールドを参考
  def initialize(zone:0, plan:nil, packetfilterid:nil, name:nil, description:nil, 
                 tags:nil, pubkey:nil, disk:{}, resolve:nil, notes:nil)
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

    @client = JSONClient.new
    @client.set_proxy_auth(SAKURA_TOKEN, SAKURA_TOKEN_SECRET)
  end

  # server.createに対応
  # 引数があると、オブジェクトの状態を変えつつそちらを使う
  def create(server_params = nil)
    create_server_instance()
    create_network_interface()
  end

  private

  # createとdestroyで独自に引数を取れるようにしておく

  #インスタンス作成
  def create_server_instance(params = nil)
    puts "Create a server for #{@name}."
    params = {
      :Server => {
        :Zone        => @zone,        :ServerPlan => @plan, :Name => @name,
        :Description => @description, :Tags => @tags
      }
    }
    response   = send_request('post','server', params)
    @server_id = response['server']['id']

    rescue => exception
      puts exception
  end

  #ネットワークインターフェイスの作成
  def create_network_interface(params = nil)
    params = {
      :interface => {
        :Server => {
          :ID => @server_id
        }
      }
    }
    response      = send_request('post', 'interface', params)
    @interface_id = response['interface']['id']

    rescue => exception
      puts exception
  end

  #ネットワークインターフェイスの接続
  def connect_network_interface(params = nil)
    @interface_id ||= params['interface_id']
    response      = send_request('put', "interface/#{interface_id}/to/switch/shared",nil)
    @server_id    = response['serverId']
    @interface_id = response['interfaceId']

    rescue => exception
      puts exception
  end

  #パケットフィルターを適用
  def apply_packet_filter(params = nil)
    @interface_id     ||= params['interface_id']
    @packet_filter_id ||= params['packet_filter_id']
    response      = send_request('put', "interface/#{interface_id}/to/packetfilter/#{@packet_filter_id}",nil)
    @server_id    = response['serverId']

    rescue => exception
      puts exception
  end

  # ディスク作成
  def create_a_disk(params = nil)
    if @disk.empty?
      @disk = params['disk']
    else
      @disk = {
        :Zone => { :ID => @zone}, 
        :Name => @name,
        :Description => @description
      }
    end
    response    = send_request('post','disk',{:Disk => @disk})
    @disk[:id] = response['disk']['id']

    rescue => exception
      puts exception
      puts 'Can not create a disk.'
  end

  def disk_connection(params = nil)
    if @disk.empty?
      @disk = params['disk']
    end
    response = send_request('put',"disk/#{@disk['id']}/to/server/#{@server_id}",nil)

    rescue => exception
      puts exception
  end

  def setup_ssh_key(params = nil)
    body = { 
      :SSHKey => {
        :PublicKey => @pubkey
      }
    }
    if @notes.empty?
      body[:SSHKey][:PublicKey][:Notes] = @notes
    end
    response = send_request('put',"disk/#{@disk['id']}/config",body)
    ....
  end

  # URI(エンドポイント)を作成する
  def create_endpoint(path)
    "#{SAKURA_BASE_URL}/#{SAKURA_ZONE_ID}/#{SAKURA_CLOUD_SUFFIX}/#{SAKURA_API_VERSION}/#{path}"
  end

  # 実際に送信する
  def send_request(http_method,path,query)
    endpoint = create_endpoint(path)
    response = @client.send(http_method,endpoint,:query => query)
    response.body.empty? ? raise "Can not send #{http_method} request.": response.body
  end
end


# main

# sakuraserverのインスタンスを作成し、createする流れ
# おそらくclassの部分は切り貼りし、mainは実際には使わないのでテスト実装

sakura =  SakuraServer.new(zone: 5, tags:"test")
sakura.create()
#sakura.create() <- createする際はこれを呼び出す
