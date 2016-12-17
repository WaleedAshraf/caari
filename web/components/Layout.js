'use strict';

import React from 'react';
import { Link } from 'react-router';

export default class Layout extends React.Component {
  render() {
    return (
      <div className="app-container">
        <div className="app-content">{this.props.children}</div>
        <footer>
          <p>
            Dont forget to like and share it in your circle.
          </p>
        </footer>
      </div>
    );
  }
}