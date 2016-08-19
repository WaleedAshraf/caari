# Description:
#   Ext scripts
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot thank - mention not
#
# Author:
#   Waleed Ashraf

uhh_what = [
	"I could tell you, but then I'd have to kill you",
	"Answering that would be a matter of national security",
	"You can't possibly compare them!",
	"Both hold a special place in my heart"
	]

module.exports = (robot) ->

	robot.respond /thank/i, (msg) ->
		msg.reply "Mention not :)"

	robot.respond /wish birthday/i, (msg) ->
		msg.send "HAPPY BIRTHDAY UMAR bhai and JUNAID bhai, Stay blessed! :birthday: :cake: :birthday: :D :) "

	robot.respond /tired|too hard|to hard|upset|bored/i, (msg) ->
	    msg.send "Take some rest!"

	robot.respond /.lol|lol|.lols|lols|haha|hahaha|lmao|funny|.funny/i, (msg) ->
	    msg.send "lols"

	robot.respond /hello|hi|hy/i, (msg) ->
		msg.send "Hello"

	robot.respond /channel add (.+)$/i, (msg) ->
		channelName = msg.match[1]
		channelID = msg.message.room
		console.log "Starting channel add: #{channelID} : #{channelName}"
		try
		  robot.brain.set channelID, channelName
		catch err
		  return msg.send err
		msg.send "Channel Added!"

	robot.respond /channel remove (.+)$/i, (msg) ->
		channelID = msg.match[1]
		console.log "Starting channel remove: #{channelID}"
		try
		  robot.brain.remove channelID
		catch err
		  return msg.send err
		msg.send "Channel Removed!"

	robot.respond /.how are you|.how you doing|.whats up/i, (msg) ->
		msg.send "I'm fine :)"

	robot.respond /.who are you|.intro|.introduction/i, (msg) ->
		msg.send "I'm a bot for developers."

	robot.respond /.your developer|.who made you|.who developed you|.who programmed you/i, (msg) ->
		msg.send "Huhbot + Waleed's skills = Amazing stuff"

	robot.respond /.great|.awesome|.amazing|.good|.well done|.good|.cool/i, (msg) ->
		msg.send "That's really good!"

	robot.respond /(which|who) is (better|worse)\?* (.*) or (.*?)\??$/i, (msg) ->
		choosen_response = msg.random [1..5]
		if choosen_response >= 3
		  msg.send msg.random uhh_what
		else
		  msg.send "Clearly #{msg.match[choosen_response + 2]} is #{msg.match[2]}"