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
	robot.router.get "/", (req, res) ->
		if(!req.secure)
			res.redirect('https://caari.io')
		else
			res.render("../views")