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
foodNum = 0
birthdayNum = 0
anniNum = 0

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

birthdayWish = [
  "Happy birthday. We hope your special day will bring you lots of happiness, love and fun. You deserve them a lot. Enjoy!",
  "On your special day, we wish you good luck. We hope this wonderful day will fill up your heart with joy and blessings. Have a fantastic birthday, celebrate happiness in every day of your life. Happy Birthday!!",
  "Special day, special person and special celebration. May all your dreams and desires come true in this coming year. Happy birthday.",
  "May your birthday be filled with many happy hours and your life with many happy birthdays. HAPPY BIRTHDAY !!",
  "Well, you are another year older and you haven't changed a bit. That's great because you are perfect just the way you are. Happy Birthday.",
  "You are like a fine wine, you keep getting better with age. Happy Birthday.",
  "Nice people like you are great to work with. Happy Birthday! Let’s celebrate the beginning of another wonderful year in your life!",
  "This job has tons of benefits and being on a team with you is one of the best ones! Have a great Birthday and a great year ahead.",
  "Birthdays mean a fresh start; a time for looking back with gratitude at the blessings of another year. It is also a time to look forward with renewed hope for bigger blessings. May you find true bliss as you face your next milestones. Happy birthday!",
  "May every moment of your life be as wonderful as you are. Happy Birthday!"
]

anniversaryWish = [
  "You are...terrifically tireless, exceptionally excellent, abundantly appreciated and...magnificent beyond words! So glad you're part of our Team! Happy Work Anniversary.",
  "May you continue to inspire us for many years to come! And may you always remember how much you are needed, respected and valued! Happy Work Anniversary.",
  "Congratulations on your Work Anniversary! May we get to celebrate many more years with you, because you are the best colleague we can ask for.",
  "Looking back on the year gone by, we couldn't have done it without you, even if we'd tried. Though your efforts we could never repay, we have this one thing to say: you've made all the difference in every way! Happy Work Anniversary!",
  "Caremerge's future is sure to be bright with team members like you! Your hard work and creativity is an inspiration to all of your colleagues. Happy Work Anniversary!",
  "Congratulations on another successful year in your career. May you take some time to reflect on your accomplishments and be blessed with continued growth and prosperity in the years ahead. Happy Work Anniversary!",
  "You are truly a valued associate! Thank you for your fervent efforts and creativity. Happy Work Anniversary!",
  "On your anniversary with Caremerge, we want you to know what a pleasure it is to work with someone so driven and dedicated as you are. Thank you for being such an important asset to our team. Happy Work Anniversary!"
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
    lunchFeebackChannel = process.env.LUNCH_FEEDBACK_CHANNEL
    data = robot.brain.data
    wishAnni = process.env.WISH_ANNI
    wishBirt = process.env.WISH_BIRT
    MAIN_ROOM = process.env.MAIN_ROOM

    getUser = (email) ->
      members = robot.brain.data.employees
      for n of members
        if (members[n].profile.email == email)
          return members[n].name
      return false

    anniWish = (tz) ->
      anniNum = Math.floor(Math.random() * (anniversaryWish.length - 0)) + 0
      anniUsers = ":balloon: :confetti_ball: :samosa: " + anniversaryWish[anniNum]
      date = today(0)
      office = '&office=' + tz
      try
        console.log("Anni url is: " + wishAnni + date + office);
        robot.http(wishAnni + date + office)
          .get() (err, res, body) ->
            if (err || !res ||res.statusCode != 200)
              console.log("Anni res err:", res.statusCode, body)
              anniUsers = "Something went wrong."
            else
              console.log("Anni res body:", body)
              if body.length > 0 && body != "null"
                body = JSON.parse(body)
                if body.length > 0
                  for n of body
                    name = if getUser(body[n].email) then ', @' + getUser(body[n].email) else ', @' + body[n].name
                    anniUsers = anniUsers.concat name
                  robot.messageRoom MAIN_ROOM,anniUsers
      catch e
        console.log("Got Anni exception",e)

    birthWish = (tz) ->
      console.log('JOB: WISHES');
      date = today(0)
      office = '&office=' + tz
      birthdayNum = Math.floor(Math.random() * (birthdayWish.length - 0)) + 0
      birtUsers = ":cake: :samosa: :birthday: " + birthdayWish[birthdayNum]
      try
        console.log("Birth url is: " + wishBirt + date + office);
        robot.http(wishBirt + date + office)
          .get() (err, res, body) ->
            if (err || !res || res.statusCode != 200)
              console.log("Birthday res err:", res.statusCode, body)
              birtUsers = "Something went wrong."
            else
              console.log("Birthday res body:",body)
              if body.length > 0 && body != "null"
                body = JSON.parse(body)
                if body.length > 0
                  for n of body
                    name = if getUser(body[n].email) then ', @' + getUser(body[n].email) else ', @' + body[n].name
                    birtUsers = birtUsers.concat name
                  robot.messageRoom MAIN_ROOM,birtUsers
            anniWish(tz)
      catch e
        console.log("Got birthday exception", e)
    
    if message is 'STAT JOB'
      console.log('JOB: STAT JOB');
      robot.http(statsGit)
      .get() (err, res, body) ->
        if (err || res.statusCode != 200)
          console.log("ERROR: #{body}")
          msg = "Something went wrong."
        else
          msg = "Github Status: #{res.statusCode}"
        robot.send envelope, msg

    else if message is 'LUNCH JOB'
      console.log('JOB: LUNCH JOB');
      date = today(0);
      console.log('Lunch url is:', lunch + date)
      menu = robot.http(lunch + date)
        .get() (err, res, resBody) ->
            console.log('today lunch', resBody)      
            if (err || res.statusCode != 200)
              console.log("ERROR: #{resBody}")
              data.lunchToday = "Something went wrong."
            else
              try
                body = JSON.parse resBody
              catch err
                body = resBody
              data.lunchToday = body

      date = today(1);
      menu = robot.http(lunch + date)
        .get() (err, res, resBody) ->       
            if (err || res.statusCode != 200)
              console.log("ERROR: #{resBody}")
              data.lunchTomorrow = "Something went wrong."
            else
              try
                body = JSON.parse resBody
              catch err
                body = resBody
              data.lunchTomorrow = body
      robot.send envelope, "lunch updated"

    else if message is 'LUNCH TODAY'
      console.log('JOB: LUNCH TODAY');
      body = data.lunchToday
      foodNum = if foodNum < food.length - 1 then foodNum + 1 else 0
      food_msg = food[foodNum]
      
      foodNum  += 1;
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
      robot.messageRoom lunchFeebackChannel,lunchMsg

    else if message is 'CLEAR REVIEW USERS'
      console.log('JOB: CLEAR REVIEW USERS')
      data.reviewUsers = [];
      robot.send envelope, "REVIEW USERS cleared!"
    
    else if message is 'WISHESUS'
      console.log('JOB: WISHESUS');
      birthWish('US')
    
    else if message is 'WISHES'
      console.log('JOB: WISHES');
      birthWish('PK')
    
    else if message is 'CLEAR TRAVIS BUILDS'
      console.log('JOB: CLEAR TRAVIS BUILDS');
      data.builds = {}
    
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