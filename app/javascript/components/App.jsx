import React, { Component } from 'react';
import Mines from '../components/game/Mines';
import configureStore from '../src/store/store';
import {Provider} from 'react-redux';
import {HashRouter as Router} from 'react-router-dom';
import {startGameBoard} from '../src/actions/actions'

const store = configureStore;
store.dispatch(startGameBoard);

class App extends Component {
  render() {
    return (
      <div className="App">
        <Provider store={store}>
          <Router>
            <div className="container">
              <Mines />
            </div>
          </Router>
        </Provider>
      </div>
    );
  }
}

export default App;