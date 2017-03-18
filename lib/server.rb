require 'socket'
require 'io/wait'
require 'server_streamer'
require 'data_packing'

class Server
  include DataPacking

  DEFAULT_PORT = 11840

  def initialize(map: map, port: port)
    @tick_counter = 0
    @map = map
    @server = TCPServer.new(port)
    @clients = []

    puts "Server running on port #{port} ..."
  end

  def tick
    puts(@tick_counter += 1)
    connect_new_clients
    check_for_input
    update_clients
  end

private

  ## NOTE: Silently absorbs IO::EAGAINWaitReadable exceptions
  def connect_new_clients
    begin
      socket = @server.accept_nonblock
      puts "#{socket.remote_address.ip_address}: Connection attempt."
      x, y, w, h = read_frame(socket)
      puts "|-> Connect: (#{x}, #{y}, #{w}, #{h})"
      write_frame([@map.w, @map.h], socket)

      @clients << ServerStreamer.new(socket, x, y, w, h)
    rescue IO::EAGAINWaitReadable
      # happens if the `accept_nonblock` call would block
      # not sure there's much to be done here, it's going
      # to happen a lot
    end
  end

  def check_for_input
    @clients.each do |c|
      begin
        c.x, c.y, c.w, c.h = read_frame(c.socket) if c.socket.ready?
      rescue NoMethodError
        puts "#{c.ip_address}: Dropping. Failure to read client."
        c.close
        @clients.delete(c)
      end
    end
  end

  def update_clients
    @clients.each do |c|
      begin
        map_data = @map.segment(c.x, c.y, c.w, c.h)

        write_frame(map_data, c.socket)
      rescue Errno::EPIPE
        @clients.delete(c)
        puts "Disconnect: (#{c.x}, #{c.y}, #{c.w}, #{c.h})"
      end
    end
  end
end
