# Description:
#   Format and display time from timestamps
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#	hubot <timestamp>  - format and display timestamp in different timezones
#	hubot <timestamp> <timezone> - format and display timestamp in requested timezone
#
# Author:
#   Chaudhry Junaid Anwar <junaidanwar10@gmail.com>

moment = require 'moment-timezone'
_ = require 'lodash'

strings = {
    INVALID_TIMESTAMP_ERROR: 'Invalid timestamp'
    INVALID_TIMEZONE_ERROR: 'Timezone not found in moment database'
}

timestampIsValid = (timestamp) -> 
    if isNaN timestamp
        return false
    return moment.unix(timestamp).isValid()

formatTimestamp = (timestamp, timezone = 'America/Chicago', format = 'YYYY-MM-DDTHH:mm:ssZZ') ->
    moment.unix(timestamp).tz(timezone).format(format);

formatOutput = (timestamp, tz = 'America/Chicago', format1 = 'YYYY-MM-DDTHH:mm:ssZZ', format2 = 'dddd, MMMM Do YYYY, h:mm:ssa') ->
    ts1 = formatTimestamp timestamp, tz, format1 
    ts2 = formatTimestamp timestamp, tz, format2
    return  tz + ':  ' + ts1 + '  -  ' + ts2 

module.exports = (robot) ->

	robot.respond /([+-]?\d+)$/i, (msg) ->
        timestamp = msg.match[1] and parseInt(msg.match[1], 10)
        if timestampIsValid timestamp
            output = formatOutput(timestamp, 'America/Chicago') + '\n' + formatOutput(timestamp, 'Asia/Karachi') + '\n' +formatOutput(timestamp, 'Etc/UTC') + '\n' +formatOutput(timestamp, 'America/Denver') + '\n' +formatOutput(timestamp, 'America/New_York') + '\n' + formatOutput(timestamp, 'America/Los_Angeles')
            msg.reply '```' + output + '```'
        else
            msg.reply strings.INVALID_TIMESTAMP_ERROR

	robot.respond /([+-]?\d+)((\s+['"]?([A-Za-z_\/]+)['"]?)+)/i, (msg) ->
        timestamp = msg.match[1] and parseInt(msg.match[1],10)
        r = /([A-Za-z_\/]+)/g
        timezones = while match = r.exec msg.match[2] 
            match[1]
        timezoneList = moment.tz.names()
        matches = _.flatten _.map timezones, (timezone) -> _.filter timezoneList, (tz) -> tz.toLowerCase().indexOf(timezone.toLowerCase()) >= 0 
        if not timestampIsValid timestamp
            return msg.reply strings.INVALID_TIMESTAMP_ERROR
        else if matches.length == 0 
            return msg.reply strings.INVALID_TIMEZONE_ERROR
        output = _.map matches, (tz) -> formatOutput(timestamp, tz)
        msg.reply '```' + output.join('\n') + '```'

