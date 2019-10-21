import { loadGame, startBoard } from '../api/gameApi';
import {
  START_GAME_SUCCESS,
  RESTAR_GAME_SUCCESS,
  CELL_STATUS_SUCCESS,
  GAME_STATUS_SUCCESS,
  LOAD_GAME_SUCCESS,
  GAME_ID_STATUS,
  PUT_FLAG,
  PUT_NUMBER,
  REMOVE_FLAG_SUCCESS,
  NOTHING
} from '../constants/actionTypes';
import {
  COVERED_COLOR,
  DISCOVERED_COLOR,
  BOMB_EXPLOSION_COLOR
  } from '../constants/colors';

export function startGameBoard() {
  let boardWithMines = loadGame()
    let data = {
      board: boardWithMines,
      game_status: 3,
      board_status: startBoard(),
      flipped_boxes: 0
    }
    fetch('/game/start', {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {'Content-Type': 'application/json' }
    })
    .then(response => response.json())
    .then(data => {
      if (data.message == "Guardado") {
        let boardStatus = data.board_status
        paintFlagsAndNumbers(boardStatus)
      } else {
        if (data.message == "Nuevo") {
          startGameExit(data);
        } else {
          if (data.message == "GameOver") {
            let boardStatus = data.board_status
            paintFlagsAndNumbers(boardStatus)
            alert("JUEGO PERDIDO")
          } else {
            if (data.message == "YouWin") {
            let boardStatus = data.board_status
            paintFlagsAndNumbers(boardStatus)
            alert("JUEGO GANADO")
            }
          }
        }
      } 
    })
    .catch(error => console.log('error', error));
}

function paintFlagsAndNumbers(boardStatus) {
  for (let row = 0; row < 10; row++) {
    for (let column = 0; column < 10; column++) {
      if (boardStatus[row][column] == 2) {
        $(`.flag.${row}${column}`).show()
        $(`.cell.${row}${column}`).css('background', DISCOVERED_COLOR);
      } else {
        if (boardStatus[row][column] == 1) {
          let data = {
            coordinates: [row, column]
          }
          fetch('/game/get/number', {
            method: 'POST',
            body: JSON.stringify(data),
            headers: {'Content-Type': 'application/json' }
          })
          .then(response => response.json())
          .then(data => {
            let currentBoard = data.board;
            let row = data.coordinates[0]
            let column = data.coordinates[1]
            let paintNumber = currentBoard[row][column];
            switch(paintNumber){
              case 0:
                $(`.cell.${row}${column}`).css('background', DISCOVERED_COLOR);
                break
              case 1:
                $(`.one.${row}${column}`).show()
                $(`.cell.${row}${column}`).css('background', DISCOVERED_COLOR);
                break
              case 2:
                $(`.two.${row}${column}`).show()
                $(`.cell.${row}${column}`).css('background', DISCOVERED_COLOR);
                break
              case 3:
                $(`.three.${row}${column}`).show()
                $(`.cell.${row}${column}`).css('background', DISCOVERED_COLOR);
                break
              case 4:
                $(`.four.${row}${column}`).show()
                $(`.cell.${row}${column}`).css('background', DISCOVERED_COLOR);
                break
              case 5:
                $(`.five.${row}${column}`).show()
                $(`.cell.${row}${column}`).css('background', DISCOVERED_COLOR);
                break
              case 6:
                $(`.six.${row}${column}`).show()
                $(`.cell.${row}${column}`).css('background', DISCOVERED_COLOR);
                break
              case 7:
                $(`.seven.${row}${column}`).show()
                $(`.cell.${row}${column}`).css('background', DISCOVERED_COLOR);
                break
              case 8:
                $(`.eight.${row}${column}`).show()
                $(`.cell.${row}${column}`).css('background', DISCOVERED_COLOR);
                break
              case 9:
                $(`.bomb.${row}${column}`).show()
                break
              case 10:
                $(`.fire.${row}${column}`).show()
                $(`.cell.${row}${column}`).css('background', BOMB_EXPLOSION_COLOR);
                break

            }
          })
          .catch(error => console.log('error', error));
        }
      }
    }
  }
  return {
    type: LOAD_GAME_SUCCESS
  }
}

function startGameExit(data) {
  return {
    type: START_GAME_SUCCESS,
    trash: data
  };
}

export function restartGame() {
  $(`.cell`).css('background', COVERED_COLOR);
  $(`.flag`).hide();
  $(`.fire`).hide();
  $(`.bomb`).hide();
  $(`.one`).hide();
  $(`.two`).hide();
  $(`.three`).hide();
  $(`.four`).hide();
  $(`.five`).hide();
  $(`.six`).hide();
  $(`.seven`).hide();
  $(`.eight`).hide();
  let boardWithMines = loadGame()
  return function(dispatch) {
    let data = {
      board: boardWithMines,
      game_status: 3,
      board_status: startBoard(),
      flipped_boxes: 0
    }
    fetch('/game/restart', {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {'Content-Type': 'application/json' }
    })
    .then(response => response.json())
    .then(data => {
      dispatch(restartGameSuccess(data));
    })
    .catch(error => console.log('error', error));
  }
}

function restartGameSuccess(data) {
  return {
    type: RESTAR_GAME_SUCCESS,
    gameId: data.game_id.$oid,
    gameStatus: data.game_status,
    flippedBoxes: data.flipped_boxes
  }
}

export function getStateForFlagCell(coordinates, decideAboutFlag, cell, props) {
  return function(dispatch) {
    let data = {
      coordinates: coordinates
    }
    fetch('/game/flag', {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {'Content-Type': 'application/json' }
    })
    .then(response => response.json())
    .then(data => {
      let cellStatus = data.cell_status
      let gameOverAlert = 0
      if (data.game_over_alert == 1) {
        gameOverAlert = 1
      }
      decideAboutFlag(cell, cellStatus, props, gameOverAlert)
      dispatch(flagSuccess(cellStatus));
    })
    .catch(error => console.log('error', error));
  }
}

function flagSuccess(cellStatus) {
  return {
    type: CELL_STATUS_SUCCESS,
    cellStatus: cellStatus
  };
}

export function getCellState(coordinates, decideAboutNumberOrBomb, cell, props) {
  return function(dispatch) {
    let data = {
      coordinates: coordinates
    }
    fetch('/game/get/cellStatus', {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {'Content-Type': 'application/json' }
    })
    .then(response => response.json())
    .then(data => {
      let cellStatus = data.cell_status
      let flagAlert = data.flag_alert
      let zerosCoordinates = 0
      let numbersCoordinates = 0
      let bombsCoordinates = 0
      let gameStatus = data.game_status
      if (data.zero_alert == 1) {
        zerosCoordinates = data.zeros_coordinates_to_uncover
        numbersCoordinates = data.numbers_coordinates_to_uncover
      }
      if (data.bomb_alert == 1) {
        bombsCoordinates = data.bombs_coordinates
      }
      decideAboutNumberOrBomb(cell, cellStatus, props, flagAlert, zerosCoordinates, numbersCoordinates, bombsCoordinates, gameStatus)
      dispatch(getCellStateSuccess(data));
    })
    .catch(error => console.log('error', error));
  }
}

function getCellStateSuccess(data) {
  return {
    type: CELL_STATUS_SUCCESS,
    cellStatus: data.cell_status,
    flippedBoxes: data.flipped_boxes,
    gameStatus: data.game_status
  };
}

export function knowTheGameState(gameStatus) {
  if (gameStatus == 3) {
    return function(dispatch) {
      fetch('/game/get/id')
      .then(response => response.json())
      .then(data =>{
        dispatch(gameIdSuccess(data));
      })
      .catch(error => console.log('error', error));
    }

  }
  return {
    type: NOTHING
  }
}

function gameIdSuccess(data) {
  return {
    type: GAME_ID_STATUS,
    gameId: data.game_id.$oid,
    gameStatus: data.game_status,
    flippedBoxes: data.flipped_boxes
  }
}

export function getStatusGame (props) {
  return {
    type: GAME_STATUS_SUCCESS,
    data: props
  }
}

export function setBoardFlag (gameId, coordinates) {
  return function(dispatch) {
    let data = {
      gameId: gameId,
      coordinates: coordinates
    }
    fetch('/game/push/flag', {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {'Content-Type': 'application/json' }
    })
    .then(response => response.json())
    .then(data => {
      dispatch(setBoardFlagSuccess(data.game_status));
    })
    .catch(error => console.log('error', error));
  }
}

function setBoardFlagSuccess (gameStatus) {
  return {
    type: PUT_FLAG,
    gameStatus: gameStatus
  }
}

export function setBoardNumber (gameId, coordinates, number) {
  return function(dispatch) {
    let data = {
      gameId: gameId,
      coordinates: coordinates,
      number: number
    }
    fetch('/game/push/Number', {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {'Content-Type': 'application/json' }
    })
    .then(response => response.json())
    .then(data => {
      dispatch(setBoardNumberSuccess(data.game_status));
    })
    .catch(error => console.log('error', error));
  }
}

function setBoardNumberSuccess (gameStatus) {
  return {
    type: PUT_NUMBER,
    gameStatus: gameStatus
  }
}

export function removeBoardFlag (gameId, coordinates) {
  return function(dispatch) {
    let data = {
      gameId: gameId,
      coordinates: coordinates
    }
    fetch('/game/remove/flag', {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {'Content-Type': 'application/json' }
    })
    .then(response => response.json())
    .then(data => {
      dispatch(removeBoardFlagSuccess(data.game_status));
    })
    .catch(error => console.log('error', error));
  }
}

function removeBoardFlagSuccess () {
  return {
    type: REMOVE_FLAG_SUCCESS
  }
}