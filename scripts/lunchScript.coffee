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

data = robot.brain.data

module.exports = (robot) ->
	robot.hear /whats in lunch today|whats lunch today|lunch today/i,(msg)->
		body = data.lunchToday
		try
			lunchMsg = "```New Main Dish:#{body.New.MainDish}\nNew Sec Dish:#{body.New.SecondaryDish}\nNew Dessert:#{body.New.Dessert}\n\nOld Main Dish:#{body.Old.MainDish}\nOld Sec Dish:#{body.Old.SecondaryDish}\nOld Dessert:#{body.Old.Dessert}```"
		catch
			lunchMsg = body
		msg.send lunchMsg

	robot.hear /whats in lunch tomorrow|whats lunch tomorrow|lunch tomorrow/i,(msg)->
		body = data.lunchTomorrow
		try
			lunchMsg = "```New Main Dish:#{body.New.MainDish}\nNew Sec Dish:#{body.New.SecondaryDish}\nNew Dessert:#{body.New.Dessert}\n\nOld Main Dish:#{body.Old.MainDish}\nOld Sec Dish:#{body.Old.SecondaryDish}\nOld Dessert:#{body.Old.Dessert}```"
		catch
			lunchMsg = body
		msg.send lunchMsg
  	