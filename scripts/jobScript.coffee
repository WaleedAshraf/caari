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

food = [
  "You don't need a silver fork to eat good food.",
  "There is no sincerer love than the love of food!",
  "Ask not what you can do for your country. Ask what’s for lunch.",
  "The only time to eat diet food is while you're waiting for the steak to cook.",
  "Never eat more than you can lift.",
  "There's no such thing as a free lunch.",
  "There is no sincerer love than the love of food!",
  "Anyone who has lost track of time when using a computer knows the propensity to dream, the urge to make dreams come true and the tendency to miss lunch.",
  "12% of employees eat because they are hungry. 88% of employees eat because it is 1 o’clock.",
  "We must explain the truth: There is no free lunch.",
  "There is no sincerer love than the love of food!",
  "The only think I like better than talking about Food is Eating.",
  "Sandwiches are wonderful. You don't need a spoon or a plate!",
  "There is no sincerer love than the love of food!",
  "One should eat to live, not live to eat.",
  "The kitchen is a sacred space.",
  "Your diet is a bank account. Good food choices are good investments.",
  "I get way too much happiness from good food.",
   "There is no sincerer love than the love of food!",
  "I think about food literally all day every day. It's a thing.",
  "I think I was immediately fed, so food became a very important part of my life.",
  "Ice cream is my comfort food.",
  "There is no sincerer love than the love of food!"
  ]

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
    wishAnni = process.env.WISH_ANNI
    wishBirt = process.env.WISH_BIRT

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

    if message is 'LUNCH TODAY'
      body = data.lunchToday
      food_num = Math.floor(Math.random() * (20 - 0 + 1)) + 0
      food_msg = food[food_num]
      try
        lunchMsg = {
              "attachments": [
                  {
                      "color": "#F35A00",
                      "author_name": "caari",             
                      "title": "Lunch Alert",
                      "text": food_msg,
                      "fields": [
                          {
                              "title":"Old: #{body.Old.Title}",
                              "value":null,
                              "short":true
                          },
                          {
                              "title": "New: #{body.New.Title}",
                              "value": null,
                              "short": true
                          },
                          {
                              "title": "Main Dish",
                              "value": body.Old.MainDish,
                              "short": true
                          },
                          {
                              "title": "Main Dish",
                              "value": body.New.MainDish,
                              "short": true
                          },
                          {
                              "title": "Sec Dish",
                              "value": body.Old.SecondaryDish,
                              "short": true
                          },
                          {
                              "title": "Sec Dish",
                              "value": body.New.SecondaryDish,
                              "short": true
                          },
                          {
                              "title": "Dessert",
                              "value": body.Old.Dessert,
                              "short": true
                          },
                          {
                              "title": "Dessert",
                              "value": body.New.Dessert,
                              "short": true
                          }
                      ]
                  }
              ]
          }
      catch
        lunchMsg = body
      robot.messageRoom commonRoom,lunchMsg

    if message is 'CLEAR REVIEW USERS'
      data.reviewUsers = [];
      robot.send envelope, "REVIEW USERS cleared!"

    getUser = (email) ->
      members = robot.brain.data.employees
      for n of members
        if (members[n].profile.email == email)
          return members[n].name
      return false

    anniWish = () ->
      anniUsers = "Happy Work Anniversaries :balloon: :confetti_ball: :samosa: "
      date = today(0)
      try
        robot.http(wishAnni + date)
          .get() (err, res, body) ->
            if err
              anniUsers = "Anniversaries Error: #{err}"
            else
              if body.length > 0 && body != null
                body = JSON.parse(body)
                for n of body
                  name = if getUser(body[n].email) then ', @' + getUser(body[n].email) else ', @' + body[n].name
                  anniUsers = anniUsers.concat name
                robot.messageRoom(commonRoom,anniUsers)
      catch e
        robot.messageRoom(commonRoom,"Got Anniversary exception! #{e}")

    if message is 'WISHES'
      date = today(0)
      birtUsers = "Happy Birthday :cake: :samosa: :birthday: "
      try
        robot.http(wishBirt + date)
        .get() (err, res, body) ->
          if err
            birtUsers = "Birthday Error: #{err}"
          else
            if body.length > 0 && body != null
              body = JSON.parse(body)
              for n of body
                name = if getUser(body[n].email) then ', @' + getUser(body[n].email) else ', @' + body[n].name
                birtUsers = birtUsers.concat name
              robot.messageRoom(commonRoom,birtUsers)
      catch e
        robot.messageRoom(commonRoom,"Got Birthday exception! #{e}")
      anniWish()

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