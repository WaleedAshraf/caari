'use strict';

import React from 'react';
import { Link } from 'react-router';

export default class CountPreview extends React.Component {
  render() {
    return (
    <div className="count-preview">
        <img src={`img/${this.props.image}`}/>
        <h2 className="name">{this.props.name}</h2>
        <h3 className="name">{this.props.count}</h3>
    </div>
    );
  }
}
