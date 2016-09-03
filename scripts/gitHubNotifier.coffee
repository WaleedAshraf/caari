module.exports = (robot) ->
	robot.router.post "/caari/gh-repo-event", (req, res) ->
		data = req.body
		commit = data.after
		commits = data.commits
		head_commit = data.head_commit
		repo = data.repository
		pusher = data.pusher
		repoName = process.env.REPO_NAME
		channelName = process.env.GH_CHANNEL_NAME
		branch = process.env.GH_BRANCH_NAME

		if (repo.name.indexOf(repo.name) != -1 && data.ref == "refs/heads/#{branch}")
			for channel in channelName
				robot.messageRoom channel, "New Commit \"#{head_commit.message}\" on Branch #{branch} to #{repo.full_name} by #{pusher.name}: #{head_commit.url}"
				console.log "GH message sent #{head_commit.message} in channel #{channel}"
		res.send(200)