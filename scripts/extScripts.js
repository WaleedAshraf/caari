module.exports = function(robot) {
  // attach hubot-arm to robot 
  require('hubot-arm')(robot);
 
  robot.respond(/RUN STAT JOB/i, function(msg) {
    // use hubot-request-arm 
    msg.robot.arm('request')({
      method: 'GET',
      url: 'https://1.bp.blogspot.com/-KW_LAtRAInM/V5ewsH7E-rI/AAAAAAAABSI/rh6uyGJj-u4DYAS4gzHGpGwq6pDw1a-aQCLcB/w800-h800/photo.jpg',
      accept: 'application/json'
    }).then(function(res) {
      console.log(res.statusCode);
      msg.send('' + res.statusCode);
    });
  });
};