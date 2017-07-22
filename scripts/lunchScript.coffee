# Description:
#   Lunch menu script
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot lunch today || lunch tomorrow
#	hubot lunch review <old|new> <1-5>
#
# Author:
#   Waleed Ashraf

lunch = process.env.LUNCH
lunchReview = process.env.LUNCH_REVIEW

today = (add) ->
  day = new Date  
  dd = day.getDate();
  dd = dd + add
  mm = day.getMonth() + 1  
  yyyy = day.getFullYear()  
  if dd < 10  
    dd = '0' + dd  
  if mm < 10  
    mm = '0' + mm  
  day = dd + '/' + mm + '/' + yyyy 

module.exports = (robot) ->
	data = robot.brain.data

	robot.respond /whats in lunch today|whats lunch today|lunch today/i,(msg)->
		body = data.lunchToday
		try
			lunchMsg = {
					    "attachments": [
					        {
                    "color": "#F35A00",
                    "author_name": "caari",					    
                    "title": "Lunch Alert",
                    "text": "There is no sincerer love than the love of food!",
                    "fields": [
                      {
                          "title":"Old: #{body.Old.Title}",
                          "value":null,
                          "short":true
                      },
                      {
                          "title": "New: #{body.New.Title}",
                          "value": null,
                          "short": true
                      },
                      {
                          "title": "Main Dish",
                          "value": body.Old.MainDish,
                          "short": true
                      },
                      {
                          "title": "Main Dish",
                          "value": body.New.MainDish,
                          "short": true
                      },
                      {
                          "title": "Sec Dish",
                          "value": body.Old.SecondaryDish,
                          "short": true
                      },
                      {
                          "title": "Sec Dish",
                          "value": body.New.SecondaryDish,
                          "short": true
                      },
                      {
                          "title": "Dessert",
                          "value": body.Old.Dessert,
                          "short": true
                      },
                      {
                          "title": "Dessert",
                          "value": body.New.Dessert,
                          "short": true
                      }
                    ]
					        }
					    ]
			}
		catch
			lunchMsg = body
		msg.send lunchMsg

	robot.respond /whats in lunch tomorrow|whats lunch tomorrow|lunch tomorrow/i,(msg)->
		body = data.lunchTomorrow
		try
			lunchMsg = {
					    "attachments": [
					        {
					            "color": "#F35A00",
					            "author_name": "caari",					    
					            "title": "Lunch Alert",
					            "text": "There is no sincerer love than the love of food!",
					            "fields": [
					                {
					                    "title":"Old: #{body.Old.Title}",
					                    "value":null,
					                    "short":true
					                },
					                {
					                    "title": "New: #{body.New.Title}",
					                    "value": null,
					                    "short": true
					                },
					                {
					                    "title": "Main Dish",
					                    "value": body.Old.MainDish,
					                    "short": true
					                },
					                {
					                    "title": "Main Dish",
					                    "value": body.New.MainDish,
					                    "short": true
					                },
					                {
					                    "title": "Sec Dish",
					                    "value": body.Old.SecondaryDish,
					                    "short": true
					                },
					                {
					                    "title": "Sec Dish",
					                    "value": body.New.SecondaryDish,
					                    "short": true
					                },
					                {
					                    "title": "Dessert",
					                    "value": body.Old.Dessert,
					                    "short": true
					                },
					                {
					                    "title": "Dessert",
					                    "value": body.New.Dessert,
					                    "short": true
					                }
					            ]
					        }
					    ]
					}
		catch
			lunchMsg = body
		msg.send lunchMsg

	robot.respond /update menu/i,(msg)->
		date = today(0);
		menu = robot.http(lunch + date)
			.get() (err, res, resBody) ->       
				if (err || res.statusCode != 200)
					console.log("ERROR: #{resBody}")
					data.lunchToday = "Something went wrong."
				else
          try
            body = JSON.parse resBody
          catch err
            body = resBody
          data.lunchToday = body
		date = today(1);
		menu = robot.http(lunch + date)
			.get() (err, res, resBody) ->       
			    if (err || res.statusCode != 200)
            console.log("ERROR: #{resBody}")
            data.lunchTomorrow = "Something went wrong."
			    else
            try
              body = JSON.parse resBody
            catch err
              body = resBody
            data.lunchTomorrow = body
	    msg.send "Menu Updated!"

	robot.respond /lunch review (new|old) ([1-5]|[1-5]\.[0-9])$/i,(msg)->
		date = today(0);
		menuType = msg.match[1].trim()
		userName = msg.message.user.name
		score = msg.match[2].trim()
		if(checkUser(userName))
			menu = robot.http( "#{lunchReview}?date=#{date}&menuType=#{menuType}&score=#{score}")
				.post() (err, res, resBody) ->       
					if (err || res.statusCode != 200)
						console.log("ERROR: #{resBody}")
						msg.send "Something went wrong.";
					else
						perct = (resBody*20).toFixed(2);
						totalScore = (resBody*1).toFixed(2);
						data.reviewUsers.push userName;
						msg.send "Thanks for review! Current status of todays *#{menuType} menu* is: #{perct}% (#{totalScore}/5)";
		else
			msg.send "Ops! You have alraedy submitted lunch review today."

#	robot.hear /lunch score/i,(msg)->
#		date = today(0);
#		menuType = msg.match[1].trim()
#		menu = robot.http("?date=" + date +"&menuType=" + menuType)
#			.post() (err, res, resBody) ->       
#				if err
#					msg.send "#{err}";
#				else
#					perct = (resBody*20).toFixed(2);
#					totalScore = (resBody*1).toFixed(2);
#					msg.send "Current status of todays lunch is: #{perct}% (#{totalScore}/5)"; 

	checkUser = (userName) ->
		try
			for n of data.reviewUsers
				if data.reviewUsers[n] == userName
					return false;
			return true;
		catch
			return false;
