# Description:
#   travis build notifications
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Author:
#   Waleed Ashraf

moment = require 'moment-timezone'
travisRoom = process.env.TRAVIS_CHANNEL
adminUser = process.env.ADMIN_USER

checkStatus = (p) ->
  if p.result == 1 || p.status == 1
   return false
  if p.status_message == 'Broken' || p.status_message == 'Failed' || p.status_message == 'Still failing'
   return false
  if p.result_message == 'Broken' || p.result_message == 'Failed' || p.result_message == 'Still failing'
   return false
  return true;

checkCancel = (p) ->
  if p.status_message == 'Canceled' || p.result_message == 'Canceled'
    return true
  return false

checkPending = (p) ->
  if p.status_message == 'Pending' || p.result_message == 'Pending'
    return true
  return false

module.exports = (robot) ->
  data = robot.brain.data
  robot.router.post "/caari/travis-build", (req, res) ->
    data.builds = if data.builds then data.builds else {}
    p = JSON.parse(req.body.payload)
    key = p.id + p.number
    console.log(key + " :status_m: " + p.status_message + " :resut_m: " + p.result_message);
    if data.builds[key]
      if checkCancel(p)
        delete data.builds[key]
        console.log("canceled deleting key");
        return res.sendStatus(200)
      if checkPending(p) || (p.finished_at == null)
        console.log("pending key");
        return res.sendStatus(200)
      start = moment(data.builds[key])
      end = moment(p.finished_at)
      console.log("endTimeIs:", end)
      difference = moment.duration(end.diff(start))
      duration = moment.utc(difference.as('milliseconds')).format('HH:mm:ss')
      console.log("durationIs:", duration);
      color = 'good'
      status = 'PASSED'
      if !checkStatus(p)
        color = 'danger'
        status = 'FAILED'
      buildMessage = {
        "attachments": [
          {
            "color": color,				    
            "title": "Travis Status",
            "text": "Build <#{p.build_url}|##{p.number}> of #{p.branch} by #{p.author_name} #{status} in #{duration}"
          }
        ]
      }
      delete data.builds[key]
      console.log("deleting key after message");
      console.log('buildMessage:', buildMessage);
      robot.messageRoom travisRoom,buildMessage
    else
      if checkStatus(p) && !checkCancel(p)
        data.builds[key] = p.started_at
        console.log(key, " adding new key: ", data.builds[key]);
      else
        console.log("key not added");
    res.sendStatus(200);
  
  robot.respond /travis builds/i, (msg) ->
    user = msg.message.user.name
    if user is adminUser
      msg.send JSON.stringify(data.builds)
    else
      msg.send "You are not authorized!"
  
  robot.respond /clear travis builds/i, (msg) ->
    user = msg.message.user.name
    if user is adminUser
      data.builds = {}
      msg.send "Cleared!"
    else
      msg.send "You are not authorized!"