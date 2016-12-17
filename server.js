'use strict';

import path from 'path';
import { Server } from 'http';
import Express from 'express';
import React from 'react';
import { renderToString } from 'react-dom/server';
import { match, RouterContext } from 'react-router';
import routes from './web/routes';
import logger from './logger.js';

// initialize the server and configure support for ejs templates
const app = new Express();
const server = new Server(app);
const env = process.env.NODE_ENV || 'development';
const port = process.env.EXPRESS_PORT || 8080;

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'web', 'views'));

// define the folder that will be used for static assets
app.use(Express.static(path.join(__dirname, 'static')));

// use SSL
app.use(requireHTTPS);

// universal routing and rendering
app.get('*', (req, res) => {
    match(
        { routes, location: req.url },
        (err, redirectLocation, renderProps) => {

            // in case of error display the error message
            if (err) {
                logger.error("err page");
                return res.status(500).send(err.message);         
            }

            // in case of redirect propagate the redirect to the browser
            if (redirectLocation) {
                logger.info("react redirect");
                return res.redirect(302, redirectLocation.pathname + redirectLocation.search);
            }

            // generate the React markup for the current route
            let markup;
            if (renderProps) {
                // if the current route matched we have renderProps
                markup = renderToString(<RouterContext {...renderProps} />);
            } else {
                // otherwise we can render a 404 page
                res.status(404);
            }

            // render the index template with the embedded React markup
            if(res.status != 404){
                logger.info("markup render");
                return res.render('index', { markup });
            } else {
                logger.info("pageNotFound");
                return res.render('pageNotFound');
            } 
        }
    );
});

// start the server
server.listen(port, err => {
    if (err) {
        return logger.error(err);
    }
    logger.info(`Server running on http://localhost:${port} [${env}]`);
});

function requireHTTPS(req, res, next) {
    if (req.headers['x-forwarded-proto'] != 'https' && env == 'production') {
        return res.redirect(301, ['https://', req.get('Host'), req.url].join(''));
    }
    res.setHeader("X-Powered-By", "caari");
    next();
}
