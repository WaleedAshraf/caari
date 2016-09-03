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
				robot.messageRoom channel, "@channel ```New Commit: \"#{head_commit.message}\"\nBranch: #{branch}\nTo: #{repo.full_name}\nBy: #{pusher.name} #{head_commit.url}```"
				console.log "GH message sent #{head_commit.message} in channel #{channel}"
		res.send(200)