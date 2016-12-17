# Description:
#   gitHub repo with branch notification 
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Config:
#	REPO_NAME: Name of repositories, comma (,) separated values.
#	GH_CHANNEL_NAME: Id of slack slack channel to post message, comma (,) separated value.
#	GB_BRANCH_NAME: Name of branch, i.e production.
#
# Author:
#   Waleed Ashraf

api_key = process.env.MAILGUN_KEY
resPusher = process.env.BLOCKED_GH_NOTIF
domain = process.env.MAILGUN_DOMAIN
fromUser = process.env.FROM_USER
toUser = process.env.TO_USER
subject = process.env.SUBJECT
mailgun = require('mailgun-js')({apiKey: api_key, domain: domain});


mailSender = (message) ->
	data = 
	  from: fromUser
	  to: toUser
	  subject: subject
	  text: message
	mailgun.messages().send data, (error, body) ->
	  console.log body
	  return

# module.exports = (robot) ->
	# robot.router.post "/caari/gh-repo-event", (req, res) ->
	# 	repoName = process.env.REPO_NAME.split(",")
	# 	branch = process.env.GH_BRANCH_NAME
	# 	data = req.body
	# 	repo = data.repository	
	# 	pusher = data.pusher
	# 	pusher = data.pusher
	# 	if (repoName.indexOf(repo.name) != -1 && data.ref == "refs/heads/#{branch}" && pusher.name != resPusher )
	# 		commits = data.commits
	# 		head_commit = data.head_commit
	# 		commit = data.after
	# 		channelName = process.env.GH_CHANNEL_NAME.split(",")
	# 		headMessage = head_commit.message.replace(/\r?\n|\r/g,"")
	# 		mailCheck = headMessage.indexOf("hotfix");
	# 		color = "warning"
	# 		title = "PR Merge Alert"
	# 		if(mailCheck != -1)
	# 			color = "danger"
	# 			title = "Hotfix Merge Alert"
	# 		for channel in channelName
	# 				githubMsg = {
	# 					    "attachments": [
	# 					        {
	# 					            "color": color,
	# 					            "author_name": "caari",					    
	# 					            "title": title,
	# 					            "text": headMessage,
	# 					            "fields": [
	# 					            	{
	# 					                    "title": "Branch",
	# 					                    "value": branch,
	# 					                    "short": true
	# 					                },
	# 					                {
	# 					                    "title": "To",
	# 					                    "value": repo.full_name,
	# 					                    "short": true
	# 					                },
	# 					                {
	# 					                    "title": "By",
	# 					                    "value": pusher.name,
	# 					                    "short": true
	# 					                },
	# 					                {
	# 					                    "title": "Link",
	# 					                    "value": head_commit.url,
	# 					                    "short": false
	# 					                }
	# 					            ]
	# 					        }
	# 					    ]
	# 					}
	# 				if(mailCheck != -1)
	# 					mailMsg = 'New Commit: ' + headMessage + "\n" + 'Branch: ' + branch + "\n" + 'To: ' + repo.full_name + "\n" + 'By: ' + pusher.name + "\n" + 'Link: ' + head_commit.url
	# 					mailSender(mailMsg)
	# 				robot.messageRoom channel, "@channel \n"
	# 				robot.messageRoom channel, githubMsg
	# 				console.log "GH message sent #{head_commit.message} in channel #{channel}"
	# 	res.send(200)