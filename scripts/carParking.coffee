# Description:
#   Car Parking PING
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#	hubot car - For ease ONLY USE NUMERIC part of car number in all commands!
#   hubot car find <number> - Send message to owner of the car to visit parking.
#   hubot car add <number> <description> - Car with <number> will be added in the list against <user> name who run commnad.
#	hubot car update <number> <description> - Will update description of car mentioned.
#   hubot car remove <number> - Car with <number> will be removed from the list.
#   hubot car list - List all the cars.
#
# Author:
#   Waleed Ashraf

module.exports = (robot) ->

	data = robot.brain.data

	robot.respond /car add (.+?[0-9]) (.+)/i, (msg) ->
		carNo = msg.match[1].trim()
		userName = msg.message.user.name
		fullName = msg.message.user.real_name
		des = msg.match[2].trim()
		if(data.car["#{carNo}"])
			return msg.send "Car #{carNo} already exist!"
		if(!/\D/.test(carNo))
			try
				if(!data.car)
					data.car = {}
				data.car["#{carNo}"] = {userName:userName, fullname:fullName, des:des}
			catch err
				return msg.send err
			msg.send "Car Added: #{carNo} : #{userName} : #{fullName} : #{des}"
		else
			return msg.send "Please only use NUMERIC part of car number!"

	robot.respond /car remove (.+)$/i, (msg) ->
		carNo = msg.match[1].trim()
		if(!/\D/.test(carNo))
			if(data.car["#{carNo}"])
				delete data.car["#{carNo}"]
				return msg.send "Car removed: #{carNo}"
			else
				return msg.send "No car found with number: #{carNo}"
		else
			return msg.send "Please only use NUMERIC part of car number!"

	robot.respond /car list$/i, (msg) ->
		cars = []
		cars.push "```Number	| Owner		| Description```"
		for car of data.car
		  carNo = car
		  userName = data.car["#{carNo}"].userName
		  fullName = data.car["#{carNo}"].fullname
		  des = data.car["#{carNo}"].des
		  cars.push "#{carNo}	| #{fullName}		| #{des}"
		if cars.length > 0
		  return msg.send cars.join '\n'
		msg.send 'No Cars'

	robot.respond /car update (.+?[0-9]) (.+)/i, (msg) ->
		carNo = msg.match[1].trim()
		des = msg.match[2].trim()
		if(!/\D/.test(carNo))
			try
				if(data.car["#{carNo}"])
					data.car["#{carNo}"].des = des
					fullName = data.car["#{carNo}"].fullname
					userName = data.car["#{carNo}"].userName
					return msg.send "Car Updated: #{carNo} : #{userName} : #{fullName} : #{des}"
				else
					return msg.send "No car found with number: #{carNo}"
			catch err
				return msg.send err
		else
			return msg.send "Please only use NUMERIC part of car number!"

	robot.respond /car find (.+)$/i, (msg) ->
		carNo = msg.match[1].trim()
		if(!/\D/.test(carNo))
			user = msg.message.user.name
			try
				if(data.car["#{carNo}"])
					owner = data.car["#{carNo}"].userName
					return msg.send "@#{owner} please visit car parking. #{user} is looking for you."
				else
					return msg.send "No car found with #{carNo} number! Try using caari car list method."
			catch err
				return msg.send err
		else
			return msg.send "Please only use NUMERIC part of car number!"
