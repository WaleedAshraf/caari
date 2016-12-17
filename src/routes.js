// src/routes.js
import React from 'react'
import { Route, IndexRoute } from 'react-router'
import Layout from './components/Layout';
import IndexPage from './components/IndexPage';
import WishPaeg from './components/WishPage';
import NotFoundPage from './components/NotFoundPage';

const routes = (
  <Route path="/" component={Layout}>
    <IndexRoute component={IndexPage}/>
    <Route path="wishpage" component={WishPage}/>
    <Route path="*" component={NotFoundPage}/>
  </Route>
);

export default routes;