class GameBoard
  include Mongoid::Document

  field :board, type: Array 
  field :game_status, type: Integer 
  field :board_status, type: Array 
  field :flipped_boxes, type: Integer 

  def self.search_current_board_game(id)
    GameBoard.any_of({_id: id}).entries[0]
  end

end