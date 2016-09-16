require_relative 'tile'
class Board
  attr_reader :grid, :bomb_count
  def initialize(bomb_count, grid = Array.new(9){Array.new(9)})
    @bomb_count = bomb_count
    @grid = grid

    @bomb_count.times do
      x = rand(9)
      y = rand(9)
      while grid[x][y].bomb
        x = rand(9)
        y = rand(9)
      end
      grid[x][y].bomb = true
    end
  end

  def fringe(pos)
    x, y = pos
    fringe_pos = []
    (x-1 .. x+1).each do |i|
      (y-1 .. y+1).each do |j|
        next if out_of_bound?(i) || out_of_bound?(j)
        #grid[i][j].revealed
        #grid[i][j].revealed = true
        fringe_pos << [i,j]
      end
    end
    fringe_pos
  end

  def reveal_tile(tile)
    tile.revealed = true
    fringes = fringe(tile)

    if check_bombs?(fringe)
      reveal_fringe(fringes)
      fringes.each do |fringe|
        reveal_tile(fringe)
      end
    end

  end

  def reveal_fringe(positions)
    positions.each do |pos|
      x, y = pos
      grid[x][y].revealed = true
    end
  end

  def check_bombs(tiles)
    tiles.none?{|tile| grid[tile].bomb?} #maybe doesn't work
  end

  def count_bombs_around(tiles)
    bombs = fringe(tiles).select{|tile| grid[tile].bomb?}
    bombs.length
  end

  def flag_bomb(pos)
    grid[pos].flag ? grid[pos].flag = false : grid[pos].flag = true
  end

  def out_of_bound?(num)
    num < 0 || num > 8
  end

  def render
    puts " " + (0..8).to_a.join(" ")
    (0..8).each do |i|
      print "#{i} "
      grid[i].each do |tile|
        if tile.flag
          print "F"
        elsif tile.revealed
          print count_bombs(tile)
        else
          print "*"
        end
      end
    end
  end

  def [](pos)
    x,y = pos
    grid[x][y]
  end

  def []=(pos, val)
    x,y = pos
    grid[x][y] = val
  end

end
