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

	robot.router.get "/", (req, res) ->
		res.render("../views")