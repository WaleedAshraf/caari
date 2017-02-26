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
  if p.status_message == 'broken' || p.status_message == 'failed' || p.status_message == 'still failing'
   return false
  if p.result_message == 'broken' || p.result_message == 'failed' || p.result_message == 'still failing'
   return false
  return true;

checkCancel = (p) ->
  if p.status_message == 'canceled' || p.result_message == 'canceled'
    return true
  return false

checkPending = (p) ->
  if p.status_message == 'pending' || p.result_message == 'pending'
    return true
  return false

module.exports = (robot) ->
  data = robot.brain.data
  robot.router.post "/caari/travis-build", (req, res) ->
    data.builds = if data.builds then data.builds else {}
    p = JSON.parse(req.body.payload)
    key = p.id + p.number
    if data.builds[key]
      if checkCancel(p)
        delete data.builds[key]
        console.log("canceled deleting key");
        return res.sendStatus(200)
      if checkPending(p)
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
            "text": "Build <#{p.build_url}|##{p.number}> of #{p.branch} (commit: #{p.commit_subject}) by #{p.author} #{status} in #{duration}"
          }
        ]
      }
      delete data.builds[key]
      console.log("deleting key after message");
      console.log('buildMessage:', buildMessage);
      robot.messageRoom travisRoom,buildMessage
    else
      data.builds[key] = p.started_at
      console.log(key, " adding new key: ",data.builds[key]);
    res.sendStatus(200);
  
  robot.respond /travis builds/i, (msg) ->
    user = msg.message.user.name
    if user is adminUser
      msg.send data.builds
    else
      msg.send "You are not authorized!"
  
  robot.respond /clear travis builds/i, (msg) ->
    user = msg.message.user.name
    if user is adminUser
      data.builds = {}
    else
      msg.send "You are not authorized!"