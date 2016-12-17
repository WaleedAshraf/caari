'use strict';

import React from 'react';
import { Link } from 'react-router';

export default class WishPage extends React.Component {
  render() {
    return (
      <div className="Wish-Page">
        <h2>Here to wish re!</h2>
        <p>
          <Link to="/">Go back to the main page</Link>
        </p>
      </div>
    );
  }
}