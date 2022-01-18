# frozen_string_literal: true

# This class layouts the board of tic-tac-toe
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(7) { Array.new(6, '   ') }
    initialize_first_to_fourth_row
    initialize_fifth_to_eighth_row
    assign_legend_to_board
  end

  private

  def initialize_first_to_fourth_row
    @board[2].map!.with_index { |_e, index| index.odd? ? ' ' : ' | ' }
    @board[3].map!.with_index do |_e, index|
      if index.zero?
        '  '
      elsif index.odd?
        '---'
      elsif index.even?
        '+'
      end
    end
  end

  def initialize_fifth_to_eighth_row
    @board.map!.with_index do |element, index|
      case index
      when 4, 6 then element.replace(@board[2])
      when 5 then element.replace(@board[3])
      else element
      end
    end
  end

  def assign_legend_to_board
    @board[0].map!.with_index { |element, index| index.odd? ? ((index + 1) / 2).to_s : element }
    @board[2][0] = 'a  '
    @board[4][0] = 'b  '
    @board[6][0] = 'c  '
  end

  public

  def show_board
    @board.map { |e| puts "  #{e.join('')}" }
  end
end

# This class takes info of the player.
class Player
  attr_reader :name, :weapon
  attr_accessor :turn

  def initialize(name, weapon)
    @name = name
    @weapon = weapon
    @turn = ' '
  end
end

# This class contains methods when starting a game of tic-tac-toe
class Game
  attr_reader :player_one, :player_two, :board
  attr_accessor :coordinates

  def initialize
    @board = Board.new
    @coordinates = %w[a1 a2 a3 b1 b2 b3 c1 c2 c3]
    start_game
  end

  private

  def welcome_message
    puts ' -------------'
    puts ' |TIC-TAC-TOE|'
    puts ' -------------'
    puts ''
  end

  def show_instruction
    puts ''
    puts 'Instructions: To input a turn, type the coordinates. e.g. a1, c3'
    puts 'The player with three consecutive X or O will win the game.'
  end

  def input_name
    puts ' '
    print 'Input the name of player that will choose X: '
    @player_one = Player.new(gets.chomp, 'X')
    print 'Input the name of player that will choose O: '
    @player_two = Player.new(gets.chomp, 'O')
  end

  def player_put_input(player)
    puts ''
    print "#{player.name}'s turn: "
    puts 'Invalid input or non-occupiable, put the right coordinates.' until coordinates.any?(player.turn = gets.chomp)
    coordinates.delete(player.turn)
    fill_board(player.turn, player.weapon)
  end

  def fill_board(turn, weapon)
    puts ''
    case turn[0]
    when 'a' then fill_board_a(turn, weapon)
    when 'b' then fill_board_b(turn, weapon)
    when 'c' then fill_board_c(turn, weapon)
    end
    board.show_board
  end

  def fill_board_a(turn, weapon)
    case turn
    when 'a1' then board.board[2][1] = weapon
    when 'a2' then board.board[2][3] = weapon
    when 'a3' then board.board[2][5] = weapon
    end
  end

  def fill_board_b(turn, weapon)
    case turn
    when 'b1' then board.board[4][1] = weapon
    when 'b2' then board.board[4][3] = weapon
    when 'b3' then board.board[4][5] = weapon
    end
  end

  def fill_board_c(turn, weapon)
    case turn
    when 'c1' then board.board[6][1] = weapon
    when 'c2' then board.board[6][3] = weapon
    when 'c3' then board.board[6][5] = weapon
    end
  end

  def player_turn
    player_put_input(player_one)
    return declare_winner(player_one.name) if check_board_pattern(player_one)

    player_put_input(player_two)
    return declare_winner(player_two.name) if check_board_pattern(player_two)

    player_turn
  end

  def check_board_pattern(player)
    winning_combination = check_row_column_diagonal.map { |e| true if e.all?(player.weapon) && e.length == 3 }
    winning_combination.any?(true)
  end

  def check_row_column_diagonal
    row = board.board.select.with_index { |_e, i| i.even? && !i.zero? }
    check_row(row) + check_column(row) + check_diagonal(row)
  end

  def check_row(row)
    row.map { |e| e.select { |elem| elem.include?('X') || elem.include?('O') } }
  end

  def check_column(row)
    [row.map { |e| e[1] }] + [row.map { |e| e[3] }] + [row.map { |e| e[5] }]
  end

  def check_diagonal(row)
    [[row[0][1], row[1][3], row[2][5]]] << [row[2][1], row[1][3], row[0][5]]
  end

  def declare_winner(name)
    puts ''
    puts "We have a winner! Congratulations, #{name}!"
  end

  def start_game
    welcome_message
    board.show_board
    show_instruction
    input_name
    player_turn
  end
end

Game.new
