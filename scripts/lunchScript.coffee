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
	robot.hear /whats in lunch today|whats lunch today|lunch today/i,(msg)->
		date = today(0);
		menu = robot.http(lunch + date)
			.get() (err, res, resBody) ->				
					if err
						lunchMsg = "Lunch Error: #{err}"
					else
						try
    						body = JSON.parse resBody
    					catch err
    						return msg.send resBody
						lunchMsg = "```New Main Dish:#{body.New.MainDish}\nNew Sec Dish:#{body.New.SecondaryDish}\nNew Dessert:#{body.New.Dessert}\n\nOld Main Dish:#{body.Old.MainDish}\nOld Sec Dish:#{body.Old.SecondaryDish}\nOld Dessert:#{body.Old.Dessert}```"
					msg.send lunchMsg


	robot.hear /whats in lunch tomorrow|whats lunch tomorrow|lunch tomorrow/i,(msg)->
		date = today(1)
		menu = robot.http(lunch + date)
			.get() (err, res, resBody) ->
				if err
					lunchMsg = "Lunch Error: #{err}"
				else
					try
						body = JSON.parse resBody
					catch err
						return msg.send resBody
					body = JSON.parse resBody
					lunchMsg = "```New Main Dish:#{body.New.MainDish}\nNew Sec Dish:#{body.New.SecondaryDish}\nNew Dessert:#{body.New.Dessert}\n\nOld Main Dish:#{body.Old.MainDish}\nOld Sec Dish:#{body.Old.SecondaryDish}\nOld Dessert:#{body.Old.Dessert}```"
				msg.send lunchMsg
  	