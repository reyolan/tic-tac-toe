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
  attr_accessor :coordinates, :board_coordinates

  def initialize
    @board = Board.new
    @coordinates = %w[a1 a2 a3 b1 b2 b3 c1 c2 c3]
    @board_coordinates = {}
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

  def initialize_board_coordinates_input(row_label, board_row)
    until row_label == 'd'
      column_label = board_column = 1
      until column_label == 4
        board_coordinates["#{row_label}#{column_label}".to_sym] = "#{board_row}#{board_column}"
        column_label += 1
        board_column += 2
      end
      row_label = row_label.next
      board_row += 2
    end
  end

  def player_put_input(player)
    puts ''
    print "#{player.name}'s turn: "
    until board_coordinates.key?(player.turn = gets.chomp.to_sym)
      print 'Invalid input or non-occupiable, put the right coordinates: '
    end
    fill_board(player.turn, player.weapon)
    board_coordinates.delete(player.turn)
  end

  def fill_board(turn, weapon)
    puts ''
    row = board_coordinates[turn][0]
    column = board_coordinates[turn][1]
    board.board[row.to_i][column.to_i] = weapon
    board.show_board
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
    initialize_board_coordinates_input('a', 2)
    player_turn
  end
end

Game.new