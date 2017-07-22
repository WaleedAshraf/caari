# Description:
#   Employee Leave Status
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#		hubot leave status - Send leaves status email to user.
#   hubot leave employee update - Update employee record.
#
# Author:
#   Waleed Ashraf <hy@waleedashraf.me>

api_key = process.env.MAILGUN_KEY || '123'
domain = process.env.MAILGUN_DOMAIN || ''
fromUser = process.env.FROM_USER || ''
subject = process.env.LEAVE_SUBJECT || ''
employeeData = process.env.EMPLOYEE_SLACK_DATA || ''
employeeLeaves = process.env.EMPLOYEE_LEAVES_STATUS || ''
mailgun = require('mailgun-js')({apiKey: api_key, domain: domain});

emailId = (userName, members) ->
	for n of members
		if members[n].name == userName
			console.log members[n].profile.email
			return members[n].profile.email

mailSender = (message, toUser) ->
	data =
	  from: fromUser
	  to: toUser
	  subject: subject
	  text: message
	mailgun.messages().send data, (error, body) ->
	  console.log body
	  return

module.exports = (robot) ->

	data = robot.brain.data

	robot.respond /leaves employee update/i, (msg) ->
		robot.http(employeeData)
			.get() (err, res, body) ->
				if (err || res.statusCode != 200)
					console.log("ERROR: #{body}")
					message = "Something went wrong."
				else
					tempBody = JSON.parse(body)
					data.employees = tempBody.members
					message = "Employee status updated successfully!"
				msg.reply message

	robot.respond /leaves status|leave status/i, (msg) ->
		# userName = msg.message.user.name
		# members = robot.brain.data.employees
		# email = emailId(userName, members)
		# if (email != null)
		# 	robot.http(employeeLeaves + email)
		# 		.get() (err, res, body) ->
		# 			if err
		# 				message = "ALERT! GOT ERROR FROM LEAVES SERVICE"
		# 			else
		# 				try
		# 					body = JSON.parse(body)
		# 					message = 'Full Name: ' + body.EmployeeName + "\n" + 'Email: ' + body.EmailID + "\n" + 'Total: ' + body.Total + "\n" + 'Taken: ' + body.Taken + "\n" + 'PTO Earned: ' + body.PTO + "\n" +'Balance: ' + body.Balance

		# 					mailSender(message, email)
		# 				catch
		# 					return msg.reply body
		# 			msg.reply "Email sent at " + email
		# else
			msg.reply "Please check leaves status through BambooHR"
