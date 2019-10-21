export function loadGame() {
  const zerosBoard = startBoard();
  return setMines(zerosBoard);
}

export function startBoard() {
  var board = [];
  var addRow = [];
  for (var row = 0; row < 10; row++) {
    for (var column = 0; column < 10; column++) {
      addRow[column] = 0;
    }
    board[row] = addRow;
    addRow = [];
  }
  return board
}

function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

function setMines(board) {
  for (var row = 0; row < 10; row++) {
    var column = getRandomInt(0, 10);
    board[row][column] = 9; 
    if (column == 0) {
      if (board[row][column+1] != 9) {
        board[row][column+1] += 1;
      }
      if ( row == 0 ) {
        if (board[row+1][column] != 9) {
          board[row+1][column] += 1;
        }
        if (board[row+1][column+1] != 9) {
          board[row+1][column+1] += 1;
        }
      } else {
        if ( row <= 8 ) {
          if (board[row-1][column] != 9) {
            board[row-1][column] += 1;
          }
          if (board[row-1][column+1] != 9) {
            board[row-1][column+1] += 1;
          }
          if (board[row+1][column] != 9) {
            board[row+1][column] += 1;
          }
          if (board[row+1][column+1] != 9) {
            board[row+1][column+1] += 1;
          }
        } else {
          if (board[row-1][column] != 9) {
            board[row-1][column] += 1;
          }
          if (board[row-1][column+1] != 9) {
            board[row-1][column+1] += 1;
          }
        }
      }
    } else {
      if (column <= 8) {
        if (board[row][column-1] != 9) {
          board[row][column-1] += 1;
        }
        if (board[row][column+1] != 9) {
          board[row][column+1] += 1;
        }
        if (row == 0) {
          if (board[row+1][column-1] != 9) {
            board[row+1][column-1] += 1;
          }
          if (board[row+1][column] != 9) {
            board[row+1][column] += 1;
          }
          if (board[row+1][column+1] != 9) {
            board[row+1][column+1] += 1;
          }
        } else {
          if (row <= 8) {
            if (board[row-1][column-1] != 9) {
              board[row-1][column-1] += 1;
            }
            if (board[row-1][column] != 9) {
              board[row-1][column] += 1;
            }
            if (board[row-1][column+1] != 9) {
              board[row-1][column+1] += 1;
            }
            if (board[row+1][column-1] != 9) {
              board[row+1][column-1] += 1;
            }
            if (board[row+1][column] != 9) {
              board[row+1][column] += 1;
            }
            if (board[row+1][column+1] != 9) {
              board[row+1][column+1] += 1;
            }
          } else {
            if (board[row-1][column-1] != 9) {
              board[row-1][column-1] += 1;
            }
            if (board[row-1][column] != 9) {
              board[row-1][column] += 1;
            }
            if (board[row-1][column+1] != 9) {
              board[row-1][column+1] += 1;
            }
          }
        }
      } else {
        if (board[row][column-1] != 9) {
          board[row][column-1] += 1;
        }
        if (row == 0) {
          if (board[row+1][column-1] != 9) {
            board[row+1][column-1] += 1;
          }
          if (board[row+1][column] != 9) {
            board[row+1][column] += 1;
          }
        } else {
          if (row <= 8) {
            if (board[row-1][column] != 9) {
              board[row-1][column] += 1;
            }
            if (board[row-1][column-1] != 9) {
              board[row-1][column-1] += 1;
            }
            if (board[row+1][column] != 9) {
              board[row+1][column] += 1;
            }
            if (board[row+1][column-1] != 9) {
              board[row+1][column-1] += 1;
            }
          } else {
            if (board[row-1][column] != 9) {
              board[row-1][column] += 1;
            }
            if (board[row-1][column-1] != 9) {
              board[row-1][column-1] += 1;
            }
          }
        }
      }
    }
  }
  return board;
}