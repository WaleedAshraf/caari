module.exports = (robot) ->
  robot.router.get "/caari/gh-repo-event", (req, res) ->
    console.log req
    robot.messageRoom 'G1YLK92RE', "Whoa, I got event!"
    res.send "200"