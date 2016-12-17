'use strict';

import React from 'react';
import { Link } from 'react-router';

export default class CountPreview extends React.Component {
  render() {
    return (
    <div className="count-preview col-xs-4">
        <img src={`img/${this.props.image}`}/>
         <div className="col-xs-2">{this.props.name}</div>
         <div className="col-xs-2">{this.props.count}</div>
    </div>
    );
  }
}
