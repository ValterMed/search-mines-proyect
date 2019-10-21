Rails.application.routes.draw do
  root 'game#index'
  post '/game/start', to: 'game#start_game' 
  post '/game/flag', to: 'game#status_flag' 
  post '/game/push/flag', to: 'game#set_flag' 
  get '/game/get/id', to: 'game#get_game_id' 
  post '/game/restart', to: 'game#reset_game' 
  post '/game/remove/flag', to: 'game#remove_flag' 
  post '/game/get/cellStatus', to: 'game#cell_status' 
  post '/game/push/Number', to: 'game#set_number' 
  post '/game/get/number', to: 'game#get_number' 
end
