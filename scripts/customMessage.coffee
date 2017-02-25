# Description:
#   work from home scripts
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot post in <room_no> message: <message>
#
# Author:
#   Sarah Noor

secretChannel = process.env.SECRET_CHANNEL
secretChannelPM = process.env.SECRET_CHANNEL_PM

module.exports = (robot) ->
  robot.respond /post in (.*)/i,(msg)->
  	if msg.message.room == secretChannel || msg.message.room == secretChannelPM #custom_message channel id
  		custom = msg.match[1]
  		#selecting one or more occurence of alphanumeric upto a space
  		room_id = custom.match(/(\w+)\s/)[1].toString()		#defining index because match() returns an array
  		#selecting any number of words after a space
  		personal_message = custom.match(/\s(.*)/)[1].toString()
  		robot.messageRoom room_id,personal_message
      