class Tile
  attr_reader :bomb, :revealed, :flag
  def initialize(bomb = false, revealed = false, flag = false)
    @bomb = bomb
    @revealed = revealed
    @flag = flag
  end

  def bomb?
    @bomb
  end
end
