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

formatOutput = (tz, timestamp, format1 = 'YYYY-MM-DDTHH:mm:ssZZ', format2 = 'dddd, MMMM Do YYYY, h:mm:ssa') ->
    ts1 = formatTimestamp timestamp, tz, format1 
    ts2 = formatTimestamp timestamp, tz, format2
    return  'Formatted time(' + tz + '):  ' + ts1 + '  -  ' + ts2 

module.exports = (robot) ->

	robot.respond /([+-]?\d+)$/i, (msg) ->
        timestamp = msg.match[1] and parseInt(msg.match[1], 10)
        if timestampIsValid timestamp
            msg.reply formatOutput 'America/Chicago', timestamp
            msg.reply formatOutput 'Asia/Karachi', timestamp
            msg.reply formatOutput 'Etc/UTC', timestamp
            msg.reply formatOutput 'America/Denver', timestamp
            msg.reply formatOutput 'America/New_York', timestamp
            msg.reply formatOutput 'America/Los_Angeles', timestamp
        else
            msg.reply strings.INVALID_TIMESTAMP_ERROR

	robot.respond /([+-]?\d+)\s+['"\\\/]?([A-Za-z\/]+)['"\\\/]?$/i, (msg) ->
        timestamp = msg.match[1] and parseInt(msg.match[1],10)
        timezone = msg.match[2] 
        timezoneList = moment.tz.names()
        matches = _.filter timezoneList, (tz) -> tz.toLowerCase().indexOf(timezone.toLowerCase()) >= 0 
        if not timestampIsValid timestamp
            return msg.reply strings.INVALID_TIMESTAMP_ERROR
        else if matches.length == 0 
            return msg.reply strings.INVALID_TIMEZONE_ERROR
        _.each matches, (tz) -> msg.reply formatOutput tz, timestamp

