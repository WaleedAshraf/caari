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
#   hubot car add <number> - Car with <number> will be added in the list against <user> name who run commnad.
#   hubot car remove <number> - Car with <number> will be removed from the list.
#   hubot car list - List all the cars.
#
# Author:
#   Waleed Ashraf

module.exports = (robot) ->

	data = robot.brain.data

	robot.respond /car add (.+)$/i, (msg) ->
		carNo = msg.match[1].trim();
		user = msg.message.user.name
		console.log "Starting car add: #{carNo}"
		try
			if(data.car)
				data.car["#{carNo}"] = user
			else
				data.car = {}
				data.car["#{carNo}"] = user
		catch err
			return msg.send err
		msg.send "Car Added!"

	robot.respond /car remove (.+)$/i, (msg) ->
		carNo = msg.match[1].trim();
		console.log "Starting car remove: #{carNo}"
		try
			delete data.car["#{carNo}"] if data.car["#{carNo}"]?
		catch err
			return msg.send err
		msg.send "Car removed!"

	robot.respond /car list$/i, (msg) ->
		cars = []
		for car,owner of data.car
		  cars.push "#{car}: #{owner}"
		if cars.length > 0
		  return msg.send cars.join '\n'
		msg.send 'No Cars'

	robot.respond /car find (.+)$/i, (msg) ->
		carNo = msg.match[1].trim();
		user = msg.message.user.name
		console.log "Finding car: #{carNo}"
		try
			if(data.car["#{carNo}"])
				owner = data.car["#{carNo}"]
				return msg.send "@#{owner} please visit car parking. #{user} is looking for you."
			else
				return msg.send "No car found with this number! Try again with only numeric part."
		catch err
			return msg.send err
