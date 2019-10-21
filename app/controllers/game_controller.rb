class GameController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
  end

  def start_game
    current_game = GameBoard.last
    if current_game[:game_status] == 3
      game = GameBoard.new(game_params)
      if game.save
        response = {message: "Nuevo", status: 200}
        render json: response, status: response[:status]
      end
    elsif current_game[:game_status] == 0
      response = {
        message: "Guardado",
        board_status: current_game[:board_status],
        status: 200}
      render json: response, status: response[:status]
    elsif current_game[:game_status] == 1
      response = {
        message: "GameOver",
        board_status: current_game[:board_status],
        status: 200}
      render json: response, status: response[:status]
    elsif current_game[:game_status] == 2
      response = {
        message: "YouWin",
        board_status: current_game[:board_status],
        status: 200}
      render json: response, status: response[:status]
    end
  end

  def get_game_id
    current_game = GameBoard.last
    response = {
      game_id: current_game[:_id], 
      game_status: current_game[:game_status],
      flipped_boxes: current_game[:flipped_boxes],
      status: 200}
    render json: response, status: response[:status]
  end

  def get_number
    current_game = GameBoard.last
    response = {board: current_game[:board], coordinates: params[:coordinates], status: 200}
    render json: response, status: response[:status]
  end

  def reset_game
    new_game = GameBoard.new(game_params)
    if new_game.save
      response = {
        game_id: new_game[:_id],
        game_status: new_game[:game_status],
        flipped_boxes: new_game[:flipped_boxes],
        status: 200}
      render json: response, status: response[:status]
    end
  end

  def status_flag
    game_status = GameBoard.last[:game_status]
    row = params[:coordinates][0].to_i
    column = params[:coordinates][1].to_i
    game_over_alert = 0
    if game_status == 1 or game_status == 2
      flag = GameBoard.last.board_status[row][column]
      game_over_alert = 1
      response = {cell_status: flag, game_over_alert: game_over_alert, status: 200}
    else
      flag = GameBoard.last.board_status[row][column]
      response = {cell_status: flag, game_over_alert: game_over_alert, status: 200}
      render json: response, status: response[:status]
    end
  end

  def set_flag
    row = params[:coordinates][0].to_i
    column = params[:coordinates][1].to_i
    current_game_board = GameBoard.search_current_board_game(params[:gameId])
    current_game_board.board_status[row][column] = 2 
    current_game_board.game_status = 0 
    if current_game_board.save 
      response = {game_status: current_game_board.game_status, status: 200}
      render json: response, status: response[:status]
    end
  end

  def remove_flag
    row = params[:coordinates][0].to_i
    column = params[:coordinates][1].to_i
    current_game_board = GameBoard.search_current_board_game(params[:gameId])
    current_game_board.board_status[row][column] = 0
    if current_game_board.save 
      response = {message: "ok", status: 200}
      render json: response, status: response[:status]
    end
  end

  def set_number
    row = params[:coordinates][0].to_i
    column = params[:coordinates][1].to_i
    current_game_board = GameBoard.search_current_board_game(params[:gameId])
    current_game_board.board_status[row][column] = 1 
    current_game_board.game_status = 0
    if current_game_board.save
      response = {game_status: current_game_board.game_status, status: 200}
      render json: response, status: response[:status]
    end
  end

  def uncover_cells(current_game_board_status, board, row, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
    max_row = 9
    max_column = 9
    min_row = 0
    min_column = 0
    if row == min_row
      if column == min_column
        if board[row][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column+1])
            zeros_coordinates_to_uncover.append([row, column+1])
            current_game_board_status[row][column+1] = 1
            uncover_cells(current_game_board_status, board, row, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column+1] > 0 and board[row][column+1] < 9
          numbers_coordinates_to_uncover.append([row, column+1, board[row][column+1]])
          current_game_board_status[row][column+1] = 1
        end

        if board[row+1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column])
            zeros_coordinates_to_uncover.append([row+1, column])
            current_game_board_status[row+1][column] = 1
            uncover_cells(current_game_board_status, board, row+1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column] > 0 and board[row+1][column] < 9
          numbers_coordinates_to_uncover.append([row+1, column, board[row+1][column]])
          current_game_board_status[row+1][column] = 1
        end

        if board[row+1][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column+1])
            zeros_coordinates_to_uncover.append([row+1, column+1])
            current_game_board_status[row+1][column+1] = 1
            uncover_cells(current_game_board_status, board, row+1, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column+1] > 0 and board[row+1][column+1] < 9
          numbers_coordinates_to_uncover.append([row+1, column+1, board[row+1][column+1]])
          current_game_board_status[row+1][column+1] = 1
        end
      
      elsif column > min_column and column < max_column 
        if board[row][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column-1])
            zeros_coordinates_to_uncover.append([row, column-1])
            current_game_board_status[row][column-1] = 1
            uncover_cells(current_game_board_status, board, row, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column-1] > 0 and board[row][column-1] < 9
          numbers_coordinates_to_uncover.append([row, column-1, board[row][column-1]])
          current_game_board_status[row][column-1] = 1
        end
        
        if board[row][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column+1])
            zeros_coordinates_to_uncover.append([row, column+1])
            current_game_board_status[row][column+1] = 1
            uncover_cells(current_game_board_status, board, row, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column+1] > 0 and board[row][column+1] < 9
          numbers_coordinates_to_uncover.append([row, column+1, board[row][column+1]])
          current_game_board_status[row][column+1] = 1
        end
        
        if board[row+1][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column-1])
            zeros_coordinates_to_uncover.append([row+1, column-1])
            current_game_board_status[row+1][column-1] = 1
            uncover_cells(current_game_board_status, board, row+1, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column-1] > 0 and board[row+1][column-1] < 9
          numbers_coordinates_to_uncover.append([row+1, column-1, board[row+1][column-1]])
          current_game_board_status[row+1][column-1] = 1
        end

        if board[row+1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column])
            zeros_coordinates_to_uncover.append([row+1, column])
            current_game_board_status[row+1][column] = 1
            uncover_cells(current_game_board_status, board, row+1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column] > 0 and board[row+1][column] < 9
          numbers_coordinates_to_uncover.append([row+1, column, board[row+1][column]])
          current_game_board_status[row+1][column] = 1
        end

        if board[row+1][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column+1])
            zeros_coordinates_to_uncover.append([row+1, column+1])
            current_game_board_status[row+1][column+1] = 1
            uncover_cells(current_game_board_status, board, row+1, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column+1] > 0 and board[row+1][column+1] < 9
          numbers_coordinates_to_uncover.append([row+1, column+1, board[row+1][column+1]])
          current_game_board_status[row+1][column+1] = 1
        end

      else 
        if board[row][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column-1])
            zeros_coordinates_to_uncover.append([row, column-1])
            current_game_board_status[row][column-1] = 1
            uncover_cells(current_game_board_status, board, row, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column-1] > 0 and board[row][column-1] < 9
          numbers_coordinates_to_uncover.append([row, column-1, board[row][column-1]])
          current_game_board_status[row][column-1] = 1
        end

        if board[row+1][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column-1])
            zeros_coordinates_to_uncover.append([row+1, column-1])
            current_game_board_status[row+1][column-1] = 1
            uncover_cells(current_game_board_status, board, row+1, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column-1] > 0 and board[row+1][column-1] < 9
          numbers_coordinates_to_uncover.append([row+1, column-1, board[row+1][column-1]])
          current_game_board_status[row+1][column-1] = 1
        end

        if board[row+1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column])
            zeros_coordinates_to_uncover.append([row+1, column])
            current_game_board_status[row+1][column] = 1
            uncover_cells(current_game_board_status, board, row+1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column] > 0 and board[row+1][column] < 9
          numbers_coordinates_to_uncover.append([row+1, column, board[row+1][column]])
          current_game_board_status[row+1][column] = 1
        end
      end

    elsif row > min_row and row < max_row 
      if column == min_column
        if board[row-1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column])
            zeros_coordinates_to_uncover.append([row-1, column])
            current_game_board_status[row-1][column] = 1
            uncover_cells(current_game_board_status, board, row-1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column] > 0 and board[row-1][column] < 9
          numbers_coordinates_to_uncover.append([row-1, column, board[row-1][column]])
          current_game_board_status[row-1][column] = 1
        end

        if board[row-1][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column+1])
            zeros_coordinates_to_uncover.append([row-1, column+1])
            current_game_board_status[row-1][column+1] = 1
            uncover_cells(current_game_board_status, board, row-1, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column+1] > 0 and board[row-1][column+1] < 9
          numbers_coordinates_to_uncover.append([row-1, column+1, board[row-1][column+1]])
          current_game_board_status[row-1][column+1] = 1
        end

        if board[row][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column+1])
            zeros_coordinates_to_uncover.append([row, column+1])
            current_game_board_status[row][column+1] = 1
            uncover_cells(current_game_board_status, board, row, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column+1] > 0 and board[row][column+1] < 9
          numbers_coordinates_to_uncover.append([row, column+1, board[row][column+1]])
          current_game_board_status[row][column+1] = 1
        end

        if board[row+1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column])
            zeros_coordinates_to_uncover.append([row+1, column])
            current_game_board_status[row+1][column] = 1
            uncover_cells(current_game_board_status, board, row+1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column] > 0 and board[row+1][column] < 9
          numbers_coordinates_to_uncover.append([row+1, column, board[row+1][column]])
          current_game_board_status[row+1][column] = 1
        end

        if board[row+1][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column+1])
            zeros_coordinates_to_uncover.append([row+1, column+1])
            current_game_board_status[row+1][column+1] = 1
            uncover_cells(current_game_board_status, board, row+1, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column+1] > 0 and board[row+1][column+1] < 9
          numbers_coordinates_to_uncover.append([row+1, column+1, board[row+1][column+1]])
          current_game_board_status[row+1][column+1] = 1
        end

      elsif column > min_column and column < max_column
        if board[row-1][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column-1])
            zeros_coordinates_to_uncover.append([row-1, column-1])
            current_game_board_status[row-1][column-1] = 1
            uncover_cells(current_game_board_status, board, row-1, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column-1] > 0 and board[row-1][column-1] < 9
          numbers_coordinates_to_uncover.append([row-1, column-1, board[row-1][column-1]])
          current_game_board_status[row-1][column-1] = 1
        end

        if board[row-1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column])
            zeros_coordinates_to_uncover.append([row-1, column])
            current_game_board_status[row-1][column] = 1
            uncover_cells(current_game_board_status, board, row-1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column] > 0 and board[row-1][column] < 9
          numbers_coordinates_to_uncover.append([row-1, column, board[row-1][column]])
          current_game_board_status[row-1][column] = 1
        end

        if board[row-1][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column+1])
            zeros_coordinates_to_uncover.append([row-1, column+1])
            current_game_board_status[row-1][column+1] = 1
            uncover_cells(current_game_board_status, board, row-1, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column+1] > 0 and board[row-1][column+1] < 9
          numbers_coordinates_to_uncover.append([row-1, column+1, board[row-1][column+1]])
          current_game_board_status[row-1][column+1] = 1
        end

        if board[row][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column-1])
            zeros_coordinates_to_uncover.append([row, column-1])
            current_game_board_status[row][column-1] = 1
            uncover_cells(current_game_board_status, board, row, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column-1] > 0 and board[row][column-1] < 9
          numbers_coordinates_to_uncover.append([row, column-1, board[row][column-1]])
          current_game_board_status[row][column-1] = 1
        end

        if board[row][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column+1])
            zeros_coordinates_to_uncover.append([row, column+1])
            current_game_board_status[row][column+1] = 1
            uncover_cells(current_game_board_status, board, row, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column+1] > 0 and board[row][column+1] < 9
          numbers_coordinates_to_uncover.append([row, column+1, board[row][column+1]])
          current_game_board_status[row][column+1] = 1
        end

        if board[row+1][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column-1])
            zeros_coordinates_to_uncover.append([row+1, column-1])
            current_game_board_status[row+1][column-1] = 1
            uncover_cells(current_game_board_status, board, row+1, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column-1] > 0 and board[row+1][column-1] < 9
          numbers_coordinates_to_uncover.append([row+1, column-1, board[row+1][column-1]])
          current_game_board_status[row+1][column-1] = 1
        end

        if board[row+1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column])
            zeros_coordinates_to_uncover.append([row+1, column])
            current_game_board_status[row+1][column] = 1
            uncover_cells(current_game_board_status, board, row+1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column] > 0 and board[row+1][column] < 9
          numbers_coordinates_to_uncover.append([row+1, column, board[row+1][column]])
          current_game_board_status[row+1][column] = 1
        end

        if board[row+1][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column+1])
            zeros_coordinates_to_uncover.append([row+1, column+1])
            current_game_board_status[row+1][column+1] = 1
            uncover_cells(current_game_board_status, board, row+1, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column+1] > 0 and board[row+1][column+1] < 9
          numbers_coordinates_to_uncover.append([row+1, column+1, board[row+1][column+1]])
          current_game_board_status[row+1][column+1] = 1
        end

      else 
        if board[row-1][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column-1])
            zeros_coordinates_to_uncover.append([row-1, column-1])
            current_game_board_status[row-1][column-1] = 1
            uncover_cells(current_game_board_status, board, row-1, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column-1] > 0 and board[row-1][column-1] < 9
          numbers_coordinates_to_uncover.append([row-1, column-1, board[row-1][column-1]])
          current_game_board_status[row-1][column-1] = 1
        end

        if board[row-1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column])
            zeros_coordinates_to_uncover.append([row-1, column])
            current_game_board_status[row-1][column] = 1
            uncover_cells(current_game_board_status, board, row-1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column] > 0 and board[row-1][column] < 9
          numbers_coordinates_to_uncover.append([row-1, column, board[row-1][column]])
          current_game_board_status[row-1][column] = 1
        end

        if board[row][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column-1])
            zeros_coordinates_to_uncover.append([row, column-1])
            current_game_board_status[row][column-1] = 1
            uncover_cells(current_game_board_status, board, row, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column-1] > 0 and board[row][column-1] < 9
          numbers_coordinates_to_uncover.append([row, column-1, board[row][column-1]])
          current_game_board_status[row][column-1] = 1
        end

        if board[row+1][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column-1])
            zeros_coordinates_to_uncover.append([row+1, column-1])
            current_game_board_status[row+1][column-1] = 1
            uncover_cells(current_game_board_status, board, row+1, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column-1] > 0 and board[row+1][column-1] < 9
          numbers_coordinates_to_uncover.append([row+1, column-1, board[row+1][column-1]])
          current_game_board_status[row+1][column-1] = 1
        end

        if board[row+1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row+1, column])
            zeros_coordinates_to_uncover.append([row+1, column])
            current_game_board_status[row+1][column] = 1
            uncover_cells(current_game_board_status, board, row+1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row+1][column] > 0 and board[row+1][column] < 9
          numbers_coordinates_to_uncover.append([row+1, column, board[row+1][column]])
          current_game_board_status[row+1][column] = 1
        end
      end

    else 
      if column == min_column
        if board[row-1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column])
            zeros_coordinates_to_uncover.append([row-1, column])
            current_game_board_status[row-1][column] = 1
            uncover_cells(current_game_board_status, board, row-1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column] > 0 and board[row-1][column] < 9
          numbers_coordinates_to_uncover.append([row-1, column, board[row-1][column]])
          current_game_board_status[row-1][column] = 1
        end
        
        if board[row-1][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column+1])
            zeros_coordinates_to_uncover.append([row-1, column+1])
            current_game_board_status[row-1][column+1] = 1
            uncover_cells(current_game_board_status, board, row-1, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column+1] > 0 and board[row-1][column+1] < 9
          numbers_coordinates_to_uncover.append([row-1, column+1, board[row-1][column+1]])
          current_game_board_status[row-1][column+1] = 1
        end

        if board[row][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column+1])
            zeros_coordinates_to_uncover.append([row, column+1])
            current_game_board_status[row][column+1] = 1
            uncover_cells(current_game_board_status, board, row, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column+1] > 0 and board[row][column+1] < 9
          numbers_coordinates_to_uncover.append([row, column+1, board[row][column+1]])
          current_game_board_status[row][column+1] = 1
        end

      elsif column > min_column and column < max_column
        if board[row][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column-1])
            zeros_coordinates_to_uncover.append([row, column-1])
            current_game_board_status[row][column-1] = 1
            uncover_cells(current_game_board_status, board, row, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column-1] > 0 and board[row][column-1] < 9
          numbers_coordinates_to_uncover.append([row, column-1, board[row][column-1]])
          current_game_board_status[row][column-1] = 1
        end

        if board[row-1][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column-1])
            zeros_coordinates_to_uncover.append([row-1, column-1])
            current_game_board_status[row-1][column-1] = 1
            uncover_cells(current_game_board_status, board, row-1, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column-1] > 0 and board[row-1][column-1] < 9
          numbers_coordinates_to_uncover.append([row-1, column-1, board[row-1][column-1]])
          current_game_board_status[row-1][column-1] = 1
        end

        if board[row-1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column])
            zeros_coordinates_to_uncover.append([row-1, column])
            current_game_board_status[row-1][column] = 1
            uncover_cells(current_game_board_status, board, row-1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column] > 0 and board[row-1][column] < 9
          numbers_coordinates_to_uncover.append([row-1, column, board[row-1][column]])
          current_game_board_status[row-1][column] = 1
        end

        if board[row-1][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column+1])
            zeros_coordinates_to_uncover.append([row-1, column+1])
            current_game_board_status[row-1][column+1] = 1
            uncover_cells(current_game_board_status, board, row-1, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column+1] > 0 and board[row-1][column+1] < 9
          numbers_coordinates_to_uncover.append([row-1, column+1, board[row-1][column+1]])
          current_game_board_status[row-1][column+1] = 1
        end

        if board[row][column+1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column+1])
            zeros_coordinates_to_uncover.append([row, column+1])
            current_game_board_status[row][column+1] = 1
            uncover_cells(current_game_board_status, board, row, column+1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column+1] > 0 and board[row][column+1] < 9
          numbers_coordinates_to_uncover.append([row, column+1, board[row][column+1]])
          current_game_board_status[row][column+1] = 1
        end

      else 
        if board[row][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row, column-1])
            zeros_coordinates_to_uncover.append([row, column-1])
            current_game_board_status[row][column-1] = 1
            uncover_cells(current_game_board_status, board, row, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row][column-1] > 0 and board[row][column-1] < 9
          numbers_coordinates_to_uncover.append([row, column-1, board[row][column-1]])
          current_game_board_status[row][column-1] = 1
        end

        if board[row-1][column-1] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column-1])
            zeros_coordinates_to_uncover.append([row-1, column-1])
            current_game_board_status[row-1][column-1] = 1
            uncover_cells(current_game_board_status, board, row-1, column-1, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column-1] > 0 and board[row-1][column-1] < 9
          numbers_coordinates_to_uncover.append([row-1, column-1, board[row-1][column-1]])
          current_game_board_status[row-1][column-1] = 1
        end

        if board[row-1][column] == 0
          unless zeros_coordinates_to_uncover.include?([row-1, column])
            zeros_coordinates_to_uncover.append([row-1, column])
            current_game_board_status[row-1][column] = 1
            uncover_cells(current_game_board_status, board, row-1, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
          end
        elsif board[row-1][column] > 0 and board[row-1][column] < 9
          numbers_coordinates_to_uncover.append([row-1, column, board[row-1][column]])
          current_game_board_status[row-1][column] = 1
        end        
      end
    end
  end
  def cell_status
    current_game_board =  GameBoard.last[:board]
    current_game = GameBoard.last
    current_game_board_status = GameBoard.last[:board_status]
    row = params[:coordinates][0].to_i
    column = params[:coordinates][1].to_i
    cell_status = current_game_board[row][column]
    flipped_boxes = current_game[:flipped_boxes]
    flag_alert = 0
    zero_alert = 0
    bomb_alert = 0
    if current_game[:board_status][row][column] == 2 or current_game[:board_status][row][column] == 1 or 
      current_game[:game_status] == 1 or 
      current_game[:game_status] == 2

      flag_alert = 1
      response = {
        cell_status: cell_status,
        flag_alert: flag_alert,
        flipped_boxes: current_game[:flipped_boxes],
        zero_alert: zero_alert,
        bomb_alert: bomb_alert,
        game_status: current_game[:game_status],
        status: 200
        }
      render json: response, status: response[:status]
    else
      if cell_status == 0
        current_game[:game_status] = 0
        zero_alert = 1
        numbers_coordinates_to_uncover = []
        zeros_coordinates_to_uncover = []
        zeros_coordinates_to_uncover.append([row, column])
        current_game_board_status[row][column] = 1
        uncover_cells(current_game_board_status, current_game_board, row, column, numbers_coordinates_to_uncover, zeros_coordinates_to_uncover)
        current_game[:board_status] = current_game_board_status
        numbers_coordinates_to_uncover.uniq!
        zeros_coordinates_to_uncover.uniq!
        flipped_boxes = numbers_coordinates_to_uncover.count + zeros_coordinates_to_uncover.count
        current_game[:flipped_boxes] += flipped_boxes
        current_game.save
        if current_game[:flipped_boxes] == 90
          current_game[:game_status] = 2
        end
        if current_game.save
          response = {
          cell_status: cell_status,
          game_status: current_game[:game_status],
          flag_alert: flag_alert,
          flipped_boxes: current_game[:flipped_boxes],
          numbers_coordinates_to_uncover: numbers_coordinates_to_uncover,
          zeros_coordinates_to_uncover: zeros_coordinates_to_uncover,
          zero_alert: zero_alert,
          bomb_alert: bomb_alert,
          status: 200
          }
          render json: response, status: response[:status]
        end
      elsif cell_status > 0 and cell_status < 9
        current_game[:flipped_boxes] += 1
        current_game[:board_status][row][column] = 1
        current_game.save
        if current_game[:flipped_boxes] == 90
          current_game[:game_status] = 2
        end
        if current_game.save
          response = {
          cell_status: cell_status,
          flag_alert: flag_alert,
          flipped_boxes: current_game[:flipped_boxes],
          zero_alert: zero_alert,
          bomb_alert: bomb_alert,
          game_status: current_game[:game_status],
          status: 200
          }
          render json: response, status: response[:status]
        end
      else 
        current_game[:game_status] = 1
        bomb_alert = 1
        bombs_coordinates = []
        current_game_board.each do |bomb_row|
          bomb_row.each do |bomb|
            if bomb == 9
              row_index = current_game_board.index(bomb_row)
              column_index = current_game_board[row_index].index(bomb)
              bombs_coordinates.append([row_index,column_index])
              current_game_board_status[row_index][column_index] = 1
            end
          end
        end
        current_game_board[row][column] = 10
        bombs_coordinates.delete([row, column]) 
        current_game[:board_status] = current_game_board_status
        current_game[:board] = current_game_board
        current_game.save
        response = {
          cell_status: cell_status,
          flag_alert: flag_alert,
          flipped_boxes: current_game[:flipped_boxes],
          zero_alert: zero_alert,
          bomb_alert: bomb_alert,
          game_status: current_game[:game_status],
          bombs_coordinates: bombs_coordinates,
          status: 200
          }
          render json: response, status: response[:status]
      end
    end
  end

  private
    def game_params
      params.require(:game).permit!
    end
end
