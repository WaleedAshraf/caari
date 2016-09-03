module.exports = (robot) ->
	robot.router.post "/caari/gh-repo-event", (req, res) ->
		data = req.body
		commit = data.after
		commits = data.commits
		head_commit = data.head_commit
		repo = data.repository
		pusher = data.pusher
		repoName = process.env.REPO_NAME.split(",")
		channelName = process.env.GH_CHANNEL_NAME.split(",")
		branch = process.env.GH_BRANCH_NAME

		if (repoName.indexOf(repo.name) != -1 && data.ref == "refs/heads/#{branch}")
			for channel in channelName
				robot.messageRoom channel, "```New Commit: \"#{head_commit.message}\" \nBranch: #{branch}			To: #{repo.full_name}\n By #{pusher.name}\n Link: #{head_commit.url}```"
				console.log "GH message sent #{head_commit.message} in channel #{channel}"
		res.send(200)