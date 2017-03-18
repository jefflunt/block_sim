class ServerStreamer
  attr_accessor :x, :y, :w, :h
  attr_reader :socket
  attr_reader :ip_address

  def initialize(socket:, x:, y:, w:, h:)
    @socket = socket
    @ip_address = socket.remote_address.ip_address
    @x, @y, @w, @h = x, y, w, h
  end

  def close
    @socket.close
  end
end
