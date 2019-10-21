import React, { Component } from 'react';
import {connect} from 'react-redux';
import Styled from 'styled-components';
import {restartGame, getStateForFlagCell, knowTheGameState, setBoardFlag} from '../../src/actions/actions'
import {getStatusGame, removeBoardFlag, getCellState, setBoardNumber} from '../../src/actions/actions'
import customFlag from '../../../assets/images/flag';
import fire from '../../../assets/images/fire';
import bombs from '../../../assets/images/fun-bomb';
import one from '../../../assets/images/one';
import two from '../../../assets/images/two';
import three from '../../../assets/images/three';
import four from '../../../assets/images/four';
import five from '../../../assets/images/five';
import six from '../../../assets/images/six';
import seven from '../../../assets/images/seven';
import eight from '../../../assets/images/eight';
import {
  COVERED_COLOR,
  DISCOVERED_COLOR,
  BOMB_EXPLOSION_COLOR,
  Button
  } from '../../src/constants/colors';

class Mines extends Component {
  constructor(props) {
    super(props);
    this.handleRestart = this.handleRestart.bind(this);
    this.buttonDetect = this.buttonDetect.bind(this);
  }
  componentDidMount() {
    this.props.startTheGame(this.props.gameStatus)
    this.props.verifyTheStatusGame(this.props)
  }
  
  handleRestart() {
    this.props.restartGame();
  }

  buttonDetect(event){
    if (event.button==2) { 
      document.oncontextmenu = function(){return false}
      if (event.target.tagName == "IMG") {
        var cell = event.target.parentElement.className;
      } else {
        var cell = event.target.className;
      }
      let position = cell.split(" ")[1];
      let coordinates = position.split("");
      this.props.consultCellStatusForFlag(coordinates, this.decideAboutFlag, cell, this.props);

    } else {
      if (event.button == 0) { 
        if (event.target.tagName == "IMG") {
          var cell = event.target.parentElement.className;
        } else {
          var cell = event.target.className;
        }
        let position = cell.split(" ")[1];
        let coordinates = position.split("");
        this.props.consultCellStatusForNumberOrBomb(coordinates, this.decideAboutNumberOrBomb, cell, this.props);
      }
    }
  }

  decideAboutNumberOrBomb(cell, cellStatus, props, flagAlert, zerosCoordinates, numbersCoordinates, bombsCoordinates, gameStatus) {
    let cellPosition = cell.split(" ");
    if (flagAlert == 0) {
      switch(cellStatus) {
        case 0:
          for (let index = 0; index < zerosCoordinates.length; index++) {
            $(`.cell.${zerosCoordinates[index][0]}${zerosCoordinates[index][1]}`).css('background', DISCOVERED_COLOR);
          }
          for (let index = 0; index < numbersCoordinates.length; index++) {
            let drawNumber = numbersCoordinates[index][2]
            switch(drawNumber) {
              case 1:
                $(`.one.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).show();
                $(`.cell.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).css('background', DISCOVERED_COLOR);
                break

              case 2:
                $(`.two.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).show();
                $(`.cell.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).css('background', DISCOVERED_COLOR);
                break

              case 3:
                $(`.three.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).show();
                $(`.cell.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).css('background', DISCOVERED_COLOR);
                break

              case 4:
                $(`.four.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).show();
                $(`.cell.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).css('background', DISCOVERED_COLOR);
                break

              case 5:
                $(`.five.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).show();
                $(`.cell.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).css('background', DISCOVERED_COLOR);
                break

              case 6:
                $(`.six.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).show();
                $(`.cell.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).css('background', DISCOVERED_COLOR);
                break

              case 7:
                $(`.seven.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).show();
                $(`.cell.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).css('background', DISCOVERED_COLOR);
                break
                
              case 8:
                $(`.eight.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).show();
                $(`.cell.${numbersCoordinates[index][0]}${numbersCoordinates[index][1]}`).css('background', DISCOVERED_COLOR);
                break
            }
          }
          if (gameStatus == 2 ) {
            alert("Has Ganado!!")
          }
          break

        case 1:
          $(`.one.${cellPosition[1]}`).show();
          $(`.${cellPosition[0]}.${cellPosition[1]}`).css('background', DISCOVERED_COLOR);
          var coordinates = cellPosition[1].split("");
          props.setNumber(props.gameId, coordinates, cellStatus)
          if (gameStatus == 2 ) {
            alert("Has Ganado!!")
          }
          break
        
        case 2:
          console.log("colocar el numero 2");
          $(`.two.${cellPosition[1]}`).show();
          $(`.${cellPosition[0]}.${cellPosition[1]}`).css('background', DISCOVERED_COLOR);
          var coordinates = cellPosition[1].split("");
          props.setNumber(props.gameId, coordinates, cellStatus)
          if (gameStatus == 2 ) {
            alert("Has Ganado!!")
          }
          break

        case 3:
          console.log("colocar el numero 3")
          $(`.three.${cellPosition[1]}`).show();
          $(`.${cellPosition[0]}.${cellPosition[1]}`).css('background', DISCOVERED_COLOR);
          var coordinates = cellPosition[1].split("");
          props.setNumber(props.gameId, coordinates, cellStatus)
          if (gameStatus == 2 ) {
            alert("Has Ganado!!")
          }
          break

        case 4:
          console.log("colocar el numero 4")
          $(`.four.${cellPosition[1]}`).show();
          $(`.${cellPosition[0]}.${cellPosition[1]}`).css('background', DISCOVERED_COLOR);
          var coordinates = cellPosition[1].split("");
          props.setNumber(props.gameId, coordinates, cellStatus)
          if (gameStatus == 2 ) {
            alert("Has Ganado!!")
          }
          break

        case 5:
          console.log("colocar el numero 5")
          $(`.five.${cellPosition[1]}`).show();
          $(`.${cellPosition[0]}.${cellPosition[1]}`).css('background', DISCOVERED_COLOR);
          var coordinates = cellPosition[1].split("");
          props.setNumber(props.gameId, coordinates, cellStatus)
          if (gameStatus == 2 ) {
            alert("Has Ganado!!")
          }
          break

        case 6:
          console.log("colocar el numero 6")
          $(`.six.${cellPosition[1]}`).show();
          $(`.${cellPosition[0]}.${cellPosition[1]}`).css('background', DISCOVERED_COLOR);
          var coordinates = cellPosition[1].split("");
          props.setNumber(props.gameId, coordinates, cellStatus)
          if (gameStatus == 2 ) {
            alert("Has Ganado!!")
          }
          break

        case 7:
          console.log("colocar el numero 7")
          $(`.seven.${cellPosition[1]}`).show();
          $(`.${cellPosition[0]}.${cellPosition[1]}`).css('background', DISCOVERED_COLOR);
          var coordinates = cellPosition[1].split("");
          props.setNumber(props.gameId, coordinates, cellStatus)
          if (gameStatus == 2 ) {
            alert("Has Ganado!!")
          }
          break
        
        case 8:
          console.log("colocar el numero 8")
          $(`.eight.${cellPosition[1]}`).show();
          $(`.${cellPosition[0]}.${cellPosition[1]}`).css('background', DISCOVERED_COLOR);
          var coordinates = cellPosition[1].split("");
          props.setNumber(props.gameId, coordinates, cellStatus)
          if (gameStatus == 2 ) {
            alert("Has Ganado!!")
          }
          break
          
        case 9:
          console.log("colocar la bomba")
          $(`.fire.${cellPosition[1]}`).show();
          $(`.${cellPosition[0]}.${cellPosition[1]}`).css('background', BOMB_EXPLOSION_COLOR);
          for (let index = 0; index < bombsCoordinates.length; index++) {
            $(`.bomb.${bombsCoordinates[index][0]}${bombsCoordinates[index][1]}`).show();
          }
          alert("Has perdido el juego, da click en Reset Game!!")
          break
      }
    }
  }

  decideAboutFlag(cell, cellStatus, props, gameOverAlert) {
    let cellPosition = cell.split(" ");
    if (gameOverAlert == 0) {
      if (cellStatus == 0) {
        $(`.flag.${cellPosition[1]}`).show()
        $(`.${cellPosition[0]}.${cellPosition[1]}`).css('background', DISCOVERED_COLOR); 
        let coordinates = cellPosition[1].split("");
        props.setFlag(props.gameId, coordinates)
      } else {
        if (cellStatus == 2) {
          $(`.flag.${cellPosition[1]}`).hide()
          $(`.${cellPosition[0]}.${cellPosition[1]}`).css('background', COVERED_COLOR); 
          let coordinates = cellPosition[1].split("");
          props.removeFlag(props.gameId, coordinates)
        }
      }
    }  
  }

  render() {
    let gameBoard = document.createElement("table");
    gameBoard.cellSpacing = "10";
    let gameBoardContent = document.createElement("tbody");
    for (let row = 0; row < 10; row++) {
      let rows = document.createElement("tr");
      for (let column = 0; column < 10; column++) {
        let columns = document.createElement("td");
        let flagImage = document.createElement("img");
        let bombImage = document.createElement("img");
        let fireImage = document.createElement("img");
        let oneImage = document.createElement("img");
        let twoImage = document.createElement("img");
        let threeImage = document.createElement("img");
        let fourImage = document.createElement("img");
        let fiveImage = document.createElement("img");
        let sixImage = document.createElement("img");
        let sevenImage = document.createElement("img");
        let eightImage = document.createElement("img");
        flagImage.src=customFlag;
        flagImage.className=`flag ${row}${column}`;
        bombImage.src=bombs;
        bombImage.className=`bomb ${row}${column}`;
        fireImage.src=fire;
        fireImage.className=`fire ${row}${column}`;
        oneImage.src=one;
        oneImage.className=`one ${row}${column}`;
        twoImage.src=two;
        twoImage.className=`two ${row}${column}`;
        threeImage.src=three;
        threeImage.className=`three ${row}${column}`;
        fourImage.src=four;
        fourImage.className=`four ${row}${column}`;
        fiveImage.src=five;
        fiveImage.className=`five ${row}${column}`;
        sixImage.src=six;
        sixImage.className=`six ${row}${column}`;
        sevenImage.src=seven;
        sevenImage.className=`seven ${row}${column}`;
        eightImage.src=eight;
        eightImage.className=`eight ${row}${column}`;
        columns.className = `cell ${row}${column}`
        columns.appendChild(flagImage).style.display = "none";
        columns.appendChild(bombImage).style.display = "none";
        columns.appendChild(fireImage).style.display = "none";
        columns.appendChild(oneImage).style.display = "none";
        columns.appendChild(twoImage).style.display = "none";
        columns.appendChild(threeImage).style.display = "none";
        columns.appendChild(fourImage).style.display = "none";
        columns.appendChild(fiveImage).style.display = "none";
        columns.appendChild(sixImage).style.display = "none";
        columns.appendChild(sevenImage).style.display = "none";
        columns.appendChild(eightImage).style.display = "none";
        rows.appendChild(columns);
      };
      gameBoardContent.appendChild(rows);
    };
    gameBoard.appendChild(gameBoardContent);

    return (
      <div className="game-container">
        <div className="header">
          <div className="title"></div>
        </div>
        <div className="restart-button">
          <Button onClick={this.handleRestart} className="btn btn-secondary">
            Reset Game
          </Button>
        </div>
        <div className="game-background">
          <div className="game-board-container" onMouseDown={this.buttonDetect}
            dangerouslySetInnerHTML={{ __html: gameBoard.outerHTML }}>
          </div>  
        </div>
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    cellStatus: state.gameReducer.cellStatus.status,
    flippedBoxes: state.gameReducer.flippedBoxes.quantity,
    gameStatus: state.gameReducer.gameStatus.status,
    gameId: state.gameReducer.gameId,
    cellValue: state.gameReducer.cellValue
  };
}

function mapDispatchToProps(dispatch) {
  return {
    startTheGame: (gameStatus) => dispatch(knowTheGameState(gameStatus)),
    verifyTheStatusGame: (props) => dispatch(getStatusGame(props)),
    restartGame: () => dispatch(restartGame()),
    consultCellStatusForFlag: (coordinates, decideAboutFlag, cell, props) => 
                          dispatch(getStateForFlagCell(coordinates, decideAboutFlag, cell, props)),
    consultCellStatusForNumberOrBomb: (coordinates, decideAboutNumberOrBomb, cell, props) => 
                          dispatch(getCellState(coordinates, decideAboutNumberOrBomb, cell, props)),
    setFlag: (gameId, coordinates) => dispatch(setBoardFlag(gameId, coordinates)),
    removeFlag: (gameId, coordinates) => dispatch(removeBoardFlag(gameId, coordinates)),
    setNumber: (gameId, coordinates, number) => dispatch(setBoardNumber(gameId, coordinates, number))
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(Mines);