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
		console.log(req.secure)
		if(req.secure)
			res.render("../views")
		else
			res.redirect('https://caari.io')