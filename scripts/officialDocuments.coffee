# Description:
#   Documents Script
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot docs outpatient form - Sends outpatient form
#   hubot docs outpatient policy - Sends outpatient policy
#   hubot docs inpatient policy - Sends inpatient form
#   hubot docs askari insurance - Sends askari insurance portal link
#   hubot docs employee handbook - Sends employee handbook doc
#   hubot docs reimb form - Sends reimbursement form
#   hubot docs reimbursement form - Sends reimbursement form
#   hubot docs all - Sends all docs
#
# Author:
#   Umar Muneer, Waleed Ashraf

module.exports = (robot) ->
  outForm = 'Outpatient Form: ' + process.env.OUTPATIENT_FORM
  outPolicy = 'Outpatient Policy: ' + process.env.OUTPATIENT_POLICY
  inPolicy = 'Inpatient Policy: ' + process.env.INPATIENT_POLICY
  askariPortal = 'Askari Insurance Portal: ' + process.env.ASKARI_INSURANCE_PORTAL
  employeeBook = 'Employee HandBook : ' + process.env.EMPLOYEE_HANDBOOK
  reimbForm = 'Equipment and Travelling Expense Reimbursement Form : ' + process.env.ACCESSORIES_REIMBURSEMENT_FORM
  robot.respond /docs outpatient form/i, (msg) ->
    msg.reply(outForm)

  robot.respond /docs outpatient policy/i, (msg) -> 
    msg.reply(outPolicy)

  robot.respond /docs inpatient policy/i, (msg) -> 
    msg.reply(inPolicy)

  robot.respond /docs askari insurance/i, (msg) -> 
    msg.reply(askariPortal)

  robot.respond /docs employee handbook/i, (msg) -> 
    msg.reply(employeeBook)

  robot.respond /docs reimb form|docs reimbursement form/i, (msg) -> 
    msg.reply(reimbForm)
  
  robot.respond /docs all/i, (msg) -> 
    msg.reply(outForm + '\n' + outPolicy + '\n' + inPolicy + '\n' + askariPortal + '\n' + employeeBook + '\n' + reimbForm)
  
