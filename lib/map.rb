class Map
  INVALID_DIMENSIONS_ERR = 'Invalid dimensions: blocks length - must be w * h'

  attr_reader :w, :h
  attr_reader :blocks

  ##
  # w - int
  # h - int
  # blocks - list of blocks; must be (w * h) in length
  def initialize(w:, h:, blocks:)
    raise INVALID_DIMENSIONS_ERR unless (w * h == blocks.length)

    @w, @h = w, h
    @blocks = blocks
  end

  ##
  # Completely replace the blocks array, and return a new instance of Map
  def update(blocks)
    Map.new(w: w, h: h, blocks: blocks)
  end

  ##
  # Return a rectangular segment of this map as defined by:
  # - seg_x, seg_y - the upper-left corner of the segment
  # - seg_w, seg_h - the width and height of the segment
  def segment(seg_x, seg_y, seg_w, seg_h)
    segment = []
    rows = []
    cols = []

    seg_h.times{|r| rows << (seg_y + r) % h }

    if (seg_x + seg_w) > w
      split_cols = (seg_x + seg_w) - w
      cols = [[seg_x, seg_w - split_cols], [0, split_cols]]
    else
      cols << [seg_x, seg_w]
    end

    rows.each do |r|
      cols.each do |cs|
        start_at = cs[0] + (r * w)
        end_at = start_at + cs[1] - 1
        segment << blocks[start_at..end_at].collect{ |b| b ? b.client_val : 0 }
      end
    end

    segment.flatten
  end
end
