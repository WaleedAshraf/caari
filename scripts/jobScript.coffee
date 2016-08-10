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


class HTTPJob extends Job

  exec: (robot) ->
    envelope = @getEnvelope()
    {message} = @meta
    statsGit = process.env.STATS_GITHUB
    statsPlan = process.env.STATS_PLANIO

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