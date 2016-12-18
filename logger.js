'use strict';

var winston = require('winston');
winston.emitErrs = true;

var logger = new(winston.Logger)({
  levels: {
    emerg: 7,
    alert: 6,
    crit: 5,
    error: 4,
    warning: 3,
    notice: 2,
    info: 1,
    debug: 0,
  },
  colors: {
    emerg: 'red',
    alert: 'yellow',
    crit: 'red',
    error: 'red',
    warning: 'red',
    notice: 'yellow',
    info: 'green',
    debug: 'blue',
  },
  transports: [
    new (winston.transports.Console)({
      colorize: true,
      handleExceptions: true,
      json: false,
      level: "emerg"
    }),
    new (winston.transports.File)({
      filename: 'trace.log',
      colorize: true,
      handleExceptions: true,
      json: false,
      level: "emerg"
    })
  ]
});

module.exports = logger;
module.exports.stream = {
    write: function(message, encoding){
        logger.info(message);
    }
};
