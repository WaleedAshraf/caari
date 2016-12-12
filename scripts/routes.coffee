# Description:
#	caari routes
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Author:
#   Waleed Ashraf

module.exports = (robot) ->

	## set up a route to redirect http to https
	robot.router.get "*", (req, res) ->
		res.redirect('https://caari.io' + req.url);

	robot.router.get "/", (req, res) ->
		res.render("../views")
		