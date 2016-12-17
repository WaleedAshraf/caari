// src/components/Layout.js
import React from 'react';
import { Link } from 'react-router';

export default class Layout extends React.Component {
  render() {
    return (
      <div className="app-container">
        <header>
          <Link to="/">
            <img className="logo" src="/img/caari.png"/>
          </Link>
        </header>
        <div className="app-content">{this.props.children}</div>
        <footer>
          <p>
            Dont forget to like and share it in your circle.<strong>caari</strong> and <strong>Share</strong>.
          </p>
        </footer>
      </div>
    );
  }
}