# Example script for starting a server
# Start with:
#   ruby example.rb

map = Map.new
sim = Sim.new(map: map)
port = ARGV[0] || Server::DEFAULT_PORT
server = Server.new(map: map, port: port)
keep_running = true

begin
  while keep_running
    sim.tick
    server.tick
  end
rescue Interrupt => e
  puts 'Stopping server ...'
end
