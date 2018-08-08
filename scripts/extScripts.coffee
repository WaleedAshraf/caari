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

adminUser = process.env.ADMIN_USER
feedbackForm = process.env.FEEDBACK_FORM
SLACK_TOKEN = process.env.HUBOT_SLACK_TOKEN

module.exports = (robot) ->

	robot.respond /feedback form/i, (msg) ->
		msg.reply feedbackForm

	robot.respond /thank/i, (msg) ->
		msg.reply "Mention not :)"

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

	robot.respond /channel update all$/i, (msg) ->
		try
			robot.http('https://slack.com/api/channels.list?token=' + SLACK_TOKEN)
				.post() (err, res, body) ->
					if (err || res.statusCode != 200)
						console.log("Channel update err", res.statusCode, body)
					else
						console.log("Got channel update res", res.statusCode)
						if body.length > 0 && body != "null"
							body = JSON.parse body
							channels = body.channels
							if channels.length > 0
								for c in channels
									console.log('added channel' + c.id + ' : ' + c.name)
									robot.brain.set c.id, c.name
								console.log('all channels added')
		catch e
			console.log("Got channels update exception", e)
			robot.send "Error"
		robot.send "Updated"

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

	robot.respond /delete obj (.+)/i, (msg) ->
		obj = msg.match[1]
		user = msg.message.user.name
		if user is adminUser
			try
				delete robot.brain.data["#{obj}"]
				return msg.send "#{obj} removed"
			catch err
				return msg.send err
		else
		  msg.send "You are not authorized!"

	robot.respond /CLEAR REVIEW USERS/i, (msg) ->
		user = msg.message.user.name
		if user is adminUser
			robot.brain.data.reviewUsers = [];
			msg.send "REVIEW USERS cleared!"
		else
			msg.send "You are not authorized!"

