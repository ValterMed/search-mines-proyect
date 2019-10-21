import {
  START_GAME_SUCCESS,
  RESTAR_GAME_SUCCESS,
  CELL_STATUS_SUCCESS,
  GAME_STATUS,
  GAME_ID_STATUS,
  PUT_FLAG,
  PUT_NUMBER  
  } from '../constants/actionTypes';
  
  const gameState = {
    data: [],
    flippedBoxes: {quantity: 0},
    gameStatus: {status: 3},
    cellStatus: {status: 0}
  };

  function gameReducer(state = gameState, action) {
    switch(action.type){
      case START_GAME_SUCCESS:
        return {
          ...state,
          trash: action.trash
        };

      case CELL_STATUS_SUCCESS:
        return {
          ...state,
          cellStatus: {status: action.cellStatus},
          flippedBoxes: {quantity: action.flippedBoxes},
          gameStatus: {status: action.gameStatus}
        }

      case GAME_STATUS:
        return {
          ...state,
          gameStatus: {status: action.gameStatus}
        };

      case GAME_ID_STATUS:
        return {
          ...state,
          gameId: action.gameId,
          gameStatus: {status: action.gameStatus},
          flippedBoxes: {quantity: action.flippedBoxes}
        };

      case PUT_FLAG:
        return {
          ...state,
          gameStatus: {status: action.gameStatus}
        }

      case PUT_NUMBER:
        return {
          ...state,
          gameStatus: {status: action.gameStatus}
        }

      case RESTAR_GAME_SUCCESS:
        return {
          ...state,
          gameId: action.gameId,
          gameStatus: {status: action.gameStatus},
          flippedBoxes: {quantity: action.flippedBoxes}
        }
      
      default:
        return state
    }
  }
  export default gameReducer;