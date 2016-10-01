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
		try
			lunchMsg = "```New:#{body.New.Title}\nMain Dish:#{body.New.MainDish}\nSec Dish:#{body.New.SecondaryDish}\nDessert:#{body.New.Dessert}\n\nOld:#{body.Old.Title}\nMain Dish:#{body.Old.MainDish}\nSec Dish:#{body.Old.SecondaryDish}\nDessert:#{body.Old.Dessert}```"
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
	  	