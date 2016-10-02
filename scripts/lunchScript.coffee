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
#   @caari lunch today || lunch tomorrow
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
		cDate = Date.now();
		try
			lunchMsg = {
					    "attachments": [
					        {
					            "color": "#F35A00",
					            "author_name": "caari",
					            "author_icon": "https://lh6.googleusercontent.com/gAA-RTRNRWVKjAR0ti8xJxnpnt8mle4Db3HAFbhj_0Zx1-EUyyjS6xuwrKvl-O93mvPnk0jlsoWr2IQ=w2880-h1470",
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
					            ],
					            "ts": cDate
					        }
					    ]
					}
		catch
			lunchMsg = body
		msg.send lunchMsg

	robot.hear /whats in lunch tomorrow|whats lunch tomorrow|lunch tomorrow/i,(msg)->
		body = data.lunchTomorrow
		try
			lunchMsg = "```New:#{body.New.Title}\nMain Dish:#{body.New.MainDish}\nSec Dish:#{body.New.SecondaryDish}\nDessert:#{body.New.Dessert}\n\nOld:#{body.Old.Title}\nMain Dish:#{body.Old.MainDish}\nSec Dish:#{body.Old.SecondaryDish}\nDessert:#{body.Old.Dessert}```"
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
	  	