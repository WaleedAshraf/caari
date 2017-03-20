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

_ = require 'lodash'

api_key = process.env.MAILGUN_KEY || ''
resPusher = process.env.BLOCKED_GH_NOTIF || ''
domain = process.env.MAILGUN_DOMAIN || ''
fromUser = process.env.FROM_USER || ''
toUser = process.env.TO_USER || ''
subject = process.env.SUBJECT || ''
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

module.exports = (robot) ->
	robot.router.post "/caari/gh-repo-event", (req, res) ->
		repoName = process.env.REPO_NAME && process.env.REPO_NAME.split(",") || ""
		branch = process.env.GH_BRANCH_NAME || "production"
		data = req.body
		repo = data.repository || ""
		pusher = data.pusher || ""
		pusher = data.pusher || ""
		if (repoName.indexOf(repo.name) != -1 && data.ref == "refs/heads/#{branch}" && pusher.name != resPusher )
			commits = data.commits
			head_commit = data.head_commit
			commit = data.after
			channelName = process.env.GH_CHANNEL_NAME && process.env.GH_CHANNEL_NAME.split(",") || ['G1YLK92RE']
			headMessage = head_commit.message.replace(/\r?\n|\r/g,"")
			mailCheck = headMessage.indexOf("hotfix");
			color = "warning"
			title = "PR Merge Alert"
			if(mailCheck != -1)
				color = "danger"
				title = "Hotfix Merge Alert"
			for channel in channelName
				githubMsg = {
					"attachments": [
						{
							"color": color,
							"author_name": "caari",
							"title": title,
							"text": headMessage,
							"fields": [
								{
									"title": "Branch",
									"value": branch,
									"short": true
								},
								{
									"title": "To",
									"value": repo.full_name,
									"short": true
								},
								{
									"title": "By",
									"value": pusher.name,
									"short": true
								},
								{
									"title": "Link",
									"value": head_commit.url,
									"short": false
								}
							]
						}
					]
				}
				if(mailCheck != -1)
					mailMsg = 'New Commit: ' + headMessage + "\n" + 'Branch: ' + branch + "\n" + 'To: ' + repo.full_name + "\n" + 'By: ' + pusher.name + "\n" + 'Link: ' + head_commit.url
					mailSender(mailMsg)
				robot.messageRoom channel, "@channel \n"
				robot.messageRoom channel, githubMsg
				console.log "GH message sent #{head_commit.message} in channel #{channel}"
		res.sendStatus(200)

	robot.router.post "/caari/gh-pr-event", (req, res) ->
		repoName = process.env.REPO_NAME && process.env.REPO_NAME.split(",") || ""
		data = req.body
		if payload in data
			data = data.payload
		pr = data.pull_request || {}
		repo = data.repository || ""
		console.log 'pr title: ', pr.title
		console.log 'action=', data.action, ', merged=', pr.merged
		if data.action != 'closed' || pr.merged != true
			console.log 'uninteresting pr action'
			res.sendStatus 200
			return
		releaseBranches = ['production', 'beta', 'staging']
		baseIndex = _.findIndex releaseBranches, (br) ->
			pr.base  && pr.base.ref && pr.base.ref.indexOf(br) >= 0
		headIndex =  _.findIndex releaseBranches, (br) ->
			pr.head && pr.head.ref && pr.head.ref.indexOf(br) >= 0
		if(repoName.indexOf(repo.name) >= 0 && baseIndex >= 0 and headIndex >= 0)
			console.log "merged interesting branch..."
			release = baseIndex < headIndex
			channelName = process.env.PR_CHANNEL_NAME && process.env.PR_CHANNEL_NAME.split(",") || ['G1YLK92RE']
			if release
				actionText =  "released"
			else
				actionText = "backmerged"
			headMessage = releaseBranches[headIndex] + " " + actionText + " to " + releaseBranches[baseIndex]
			mergedBy = pr.merged_by && pr.merged_by.login
			color = if release then "good" else "#cccccc"
			title = if release then "Release Alert" else "Backmerge Alert"
			for channel in channelName
				githubMsg = {
					"attachments": [
						{
							"color": color,
							"title": headMessage,
							"fields": [
								{
									"title": "To Branch",
									"value": releaseBranches[baseIndex],
									"short": true
								},
								{
									"title": "From Branch",
									"value": releaseBranches[headIndex],
									"short": true
								},
								{
									"title": "Repo",
									"value": repo.full_name,
									"short": true
								},
								{
									"title": "Merged By",
									"value": mergedBy,
									"short": true
								},
								{
									"title": "Link",
									"value": pr.url,
									"short": false
								}
							]
						}
					]
				}
				robot.messageRoom channel, "@channel \n"
				robot.messageRoom channel, githubMsg
				console.log 'release/backmerge alert: ' + headMessage
		res.sendStatus(200)
