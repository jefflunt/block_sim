class Map
  DEFAULT_WIDTH = 200
  DEFAULT_HEIGHT = 200

  attr_reader :w, :h
  attr_reader :cells

  def initialize(w: DEFAULT_WIDTH, h: DEFAULT_HEIGHT, cells:)
    @w, @h = w, h
    @cells = cells
  end

  def update_cells(cells)
    Map.new(w: w, h: h, cells: cells)
  end

  def segment(seg_x, seg_y, seg_w, seg_h)
    segment = []
    rows = []
    cols = []

    seg_h.times{|r| rows << (seg_y + r) % @h }

    if (seg_x + seg_w) > @w
      split_cols = (seg_x + seg_w) - @w
      cols = [[seg_x, seg_w - split_cols], [0, split_cols]]
    else
      cols << [seg_x, seg_w]
    end

    rows.each do |r|
      cols.each do |cs|
        start_at = cs[0] + (r * @w)
        end_at = start_at + cs[1] - 1
        segment << @cells[start_at..end_at].collect{ |c| c.energy }
      end
    end

    segment.flatten
  end
end
