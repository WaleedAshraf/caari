// src/components/IndexPage.js
import React from 'react';
import AthletePreview from './CountPreview';
import count from '../data/count';

export default class IndexPage extends React.Component {
  render() {
    return (
      <div className="home">
        <div className="user-count">
          {<AthletePreview key={count.number} />}
        </div>
        <div className="user-login">
          <Link to="/wishpage">Try it!</Link>
        </div>
      </div>
    );
  }
}