# Description:
#   Lunch menu script
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot lunch today || lunch tomorrow
#
# Author:
#   Waleed Ashraf

lunch = process.env.LUNCH

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

module.exports = (robot) ->
	data = robot.brain.data

	robot.hear /whats in lunch today|whats lunch today|lunch today/i,(msg)->
		body = data.lunchToday
		try
			lunchMsg = {
					    "attachments": [
					        {
					            "color": "#F35A00",
					            "author_name": "caari",					    
					            "title": "Lunch Alert",
					            "text": "There is no sincerer love than the love of food!",
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
		msg.send lunchMsg

	robot.hear /whats in lunch tomorrow|whats lunch tomorrow|lunch tomorrow/i,(msg)->
		body = data.lunchTomorrow
		try
			lunchMsg = {
					    "attachments": [
					        {
					            "color": "#F35A00",
					            "author_name": "caari",					    
					            "title": "Lunch Alert",
					            "text": "There is no sincerer love than the love of food!",
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
		msg.send lunchMsg

	robot.hear /update menu/i,(msg)->
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
	    msg.send "Menu Updated!"

	robot.hear /lunch review (new|old) (\d?[0-5])/i,(msg)->
		date = today(0);
		menuType = msg.match[1].trim()
		userName = msg.message.user.name
		score = msg.match[2].trim()
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
	    msg.send "Menu Updated!"
	  	