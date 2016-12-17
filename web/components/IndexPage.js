'use strict';

import React from 'react';
import CountPreview from './CountPreview';
import counts from '../data/counts';
import { Link } from 'react-router';

export default class IndexPage extends React.Component {
  render() {
    return (
      <div className="home">
        <div className="user-login">
          <Link to="/wishpage">Try it!</Link>
        </div>
      </div>
    );
  }
}