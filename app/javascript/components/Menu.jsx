import React, { Component } from 'react';
import { NavLink } from 'react-router-dom';

class Menu extends Component {
  constructor(props) {
    super(props);
  }
  render() {
    return ( 
      <div className="Menu">
        <nav className="navbar navbar-expand-lg navbar-dark bg-dark">
          <ul className="navbar-nav mr-auto">
            <li className="nav-item">
              <NavLink exact className="nav-link" activeClassName="active" to="/index/game">
                Mines Game
              </NavLink>
            </li>
          </ul>
        </nav>
      </div>
    );
  }
}

export default Menu;