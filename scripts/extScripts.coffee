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

module.exports = (robot) ->

	robot.hear /thank/i, (msg) ->
		msg.reply "Mention not :)"

	robot.hear /tired|too hard|to hard|upset|bored/i, (msg) ->
	    msg.send "Take some rest!"

	robot.hear /.lol|lol|.lols|lols|haha|hahaha|lmao|funny|.funny/i, (msg) ->
	    msg.send "Take some rest!"

	robot.respond /hello|hi|hy/i, (msg) ->
		msg.send "Hello"

	robot.respond /.how are you|.how you doing|.whats up/i, (msg) ->
		msg.send "I'm fine :)"

	robot.respond /.who are you|.intro|.introduction/i, (msg) ->
		msg.send "I'm a bot for developers."

	robot.respond /.your developer|.who made you|.who developed you|.who programmed you/i, (msg) ->
		msg.send "Huhbot + Waleed's skills = Amazing stuff"