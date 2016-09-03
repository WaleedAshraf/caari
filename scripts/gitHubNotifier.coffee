module.exports = (robot) ->
  robot.router.get "/caari/gh-repo-event", (req, res) ->
    console.log "Hi"
    res.send "OK"