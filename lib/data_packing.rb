module DataPacking
  FRAME_PACKING = 'L>*'

  def read_frame(socket)
    length = unpack(socket.read(4))[0]
    unpack(socket.read(length * 4))
  end

  def write_frame(data, socket)
    socket.write(pack([data.length]))
    socket.write(pack(data))
  end

  def pack(array)
    array.pack(FRAME_PACKING)
  end

  def unpack(array)
    array.unpack(FRAME_PACKING)
  end
end
