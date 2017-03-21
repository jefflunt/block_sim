# Example script to start a server

$LOAD_PATH.unshift 'lib'

require 'map'
require 'sim'
require 'server'

##
# Build stating data
#
# For `blocks`, use an array of whatever class you have. The simulation treats
# `nil` elements as empty elements.
blocks = Array.new(200 * 200)
map = Map.new(w: 200, h: 200, blocks: blocks)
sim = Sim.new(map: map, turn_length: 0.5)

##
# Build TCP server
port = ARGV[0] || Server::DEFAULT_PORT
server = Server.new(sim: sim, port: port)
keep_running = true

##
# Loop until interrupted (e.g. Ctrl+C, or SIGTERM)
begin
  while keep_running
    sim.step
    server.step
  end
rescue Interrupt => e
  puts 'Stopping server ...'
end
