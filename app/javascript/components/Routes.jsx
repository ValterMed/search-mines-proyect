import React, { Component } from 'react';
import Mines from './game/Mines';
import {Route, Switch} from 'react-router-dom'

class Routes extends Component {
  render() {
    return (
      <div className="Routes">
        <Switch>
          <Route exact path="/index/game" component={Mines} />
        </Switch>
      </div>
    );
  }
}

export default Routes;