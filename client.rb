$LOAD_PATH.unshift 'lib'

require 'socket'
require 'curses'
require 'server'
require 'data_packer'

include Curses
include DataPacker

def check_user_input(x, y, w, h, sim_w, sim_h)
  case getch
    when 'w' then y = (y - 1) % sim_h
    when 'a' then x = (x - 1) % sim_w
    when 's' then y = (y + 1) % sim_h
    when 'd' then x = (x + 1) % sim_w
  end

  [x, y, w, h]
end

## main

Curses.init_screen
Curses.timeout = 0
Curses.nl
Curses.noecho
Curses.curs_set(0)
x, y, w, h = 0, 0, Curses.cols, Curses.lines

host = ARGV[0] || 'localhost'
port = ARGV[1] || Server::DEFAULT_PORT
puts "Connecting to #{host} ..."
socket = TCPSocket.new(host, port)
write_frame([x, y, w, h], socket)
sim_w, sim_h = read_frame(socket)

while true
  x, y, w, h = check_user_input(x, y, w, h, sim_w, sim_h)
  write_frame([x, y, w, h], socket)

  view = read_frame(socket)

  clear
  setpos(0, 0)
  view.each{|tile| tile == 0 ? addch(' ') : addch('.') }

  setpos(0, 0)
  addstr("(#{x}, #{y})")

  refresh
end

socket.close
