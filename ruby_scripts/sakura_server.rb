class SakuraServer

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
end


sakura =  SakuraServer.new(zone: 5, tags:"test")


