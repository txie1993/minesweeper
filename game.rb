require_relative 'board'
require_relative 'tile'

class Game

  def initialize(board = Board.new(rand(15)))
    @board = board
    @over = false
  end

  def click_tile(tile)
    @over = true if tile.bomb?
    @board.reveal_tile(tile)
  end

  def play_turn
    until won? || lost?
      @board.reveal
      puts "Type 0 to click or 1 to flag"
      choice = Integer(gets.chomp)
      puts "Type a position"
      position = gets.chomp.split(",").map{|el| Integer(el)}
      if (choice == 0)
        next if @board[position].flag
        click_tile(position)
      else
        @board.flag_bomb(position)
      end
    end
    if (won?)
      puts "Hey you won the game!"
    elsif (lost?)
      puts "Oh no! You hit the bomb! :( "
    end
  end

  def lost?
    @over
  end

  def won?
    unrevealed = @board.grid.flatten.select{|tile| tile.revealed == false}
    unrevealed.length == @board.bomb_count
  end
end

game = Game.new
game.run
