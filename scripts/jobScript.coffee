# Description:
#   Example scripts for @moqada/hubot-schedule-helper
#
# Commands:
#   hubot schedule add "<cron pattern>" <message> - Add Schedule
#   hubot schedule cancel <id> - Cancel Schedule
#   hubot schedule update <id> <message> - Update Schedule
#   hubot schedule list - List Schedule
{Scheduler, Job, JobNotFound, InvalidPattern} = require '@moqada/hubot-schedule-helper'

storeKey = 'hubot-schedule-helper-HTTPJob:schedule'

today = (add) ->
  day = new Date  
  dd = day.getDate();
  dd = dd + add
  mm = day.getMonth() + 1  
  yyyy = day.getFullYear()  
  if dd < 10  
    dd = '0' + dd  
  if mm < 10  
    mm = '0' + mm  
  day = dd + '/' + mm + '/' + yyyy 

class HTTPJob extends Job

  exec: (robot) ->
    envelope = @getEnvelope()
    {message} = @meta
    statsGit = process.env.STATS_GITHUB
    statsPlan = process.env.STATS_PLANIO
    lunch = process.env.LUNCH
    commonRoom = process.env.COMMON_ROOM
    data = robot.brain.data

    second = (message,msg) ->
      monthmsg = robot.http(statsGit)
          .get() (err, res, body) ->
            if err
              msgt = "Github Error: #{err}"
            else
              msgt = "Github Status: #{res.statusCode}"
            finalmsg = "```JobTitle: #{message}\n#{msg}\n#{msgt} ```"
            robot.send envelope, finalmsg

    if message is 'STAT JOB'
      robot.http(statsPlan)
      .get() (err, res, body) ->
        if err
          msg = "PlanIO Error: #{err}"
        else
          msg = "PlanIO Status: #{res.statusCode}"
        second(message, msg)
    else
      robot.send envelope, message

    if message is 'LUNCH JOB'
      date = today(0);
      menu = robot.http(lunch + date)
        .get() (err, res, resBody) ->       
            if err
              data.lunchToday = "Lunch Error: #{err}"
            else
              try
                body = JSON.parse resBody
              catch err
                body = resBody
              data.lunchToday = body

      date = today(1);
      menu = robot.http(lunch + date)
        .get() (err, res, resBody) ->       
            if err
              data.lunchTomorrow = "Lunch Error: #{err}"
            else
              try
                body = JSON.parse resBody
              catch err
                body = resBody
              data.lunchTomorrow = body
      robot.send envelope, "lunch updated"

    if message is 'TODAY LUNCH'
      body = data.lunchToday
      try
        lunchMsg = "@here Lunch Today```New Main Dish:#{body.New.MainDish}\nNew Sec Dish:#{body.New.SecondaryDish}\nNew Dessert:#{body.New.Dessert}\n\nOld Main Dish:#{body.Old.MainDish}\nOld Sec Dish:#{body.Old.SecondaryDish}\nOld Dessert:#{body.Old.Dessert}```"
      catch
        lunchMsg = body
      robot.messageRoom commonRoom,lunchMsg

module.exports = (robot) ->
  scheduler = new Scheduler({robot, storeKey, job: HTTPJob})

  robot.respond /schedule add "(.+)" (.+)$/i, (res) ->
    [pattern, message] = res.match.slice(1)
    {user} = res.message
    try
      job = scheduler.createJob({pattern, user, meta: {message}})
      res.send "Created: #{job.id}"
    catch err
      if err.name is InvalidPattern.name
        return res.send 'invalid pattern!!!'
      res.send err.message

  robot.respond /schedule cancel (\d+)$/i, (res) ->
    [id] = res.match.slice(1)
    try
      scheduler.cancelJob id
      res.send "Canceled: #{id}"
    catch err
      if err.name is JobNotFound.name
        return res.send "Job not found: #{id}"
      res.send err

  robot.respond /schedule list$/i, (res) ->
    jobs = []
    for id, job of scheduler.jobs
      jobs.push "#{id}: \"#{job.pattern}\" ##{job.getRoom()} #{job.meta.message}"
    if jobs.length > 0
      return res.send jobs.join '\n'
    res.send 'No jobs'

  robot.respond /schedule update (\d+) (.+)$/i, (res) ->
    [id, message] = res.match.slice(1)
    try
      scheduler.updateJob id, {message}
      res.send "#{id}: Updated"
    catch err
      if err.name is JobNotFound.name
        return res.send "Job not found: #{id}"
      res.send err