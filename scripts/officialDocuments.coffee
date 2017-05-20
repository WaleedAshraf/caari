module.exports = (robot) ->
  robot.respond /outpatient form/i, (msg) ->
    msg.reply(process.env.OUTPATIENT_FORM);

  robot.respond /outpatient policy/i, (msg) -> 
    msg.reply(process.env.OUTPATIENT_POLICY);

  robot.respond /inpatient policy/i, (msg) -> 
    msg.reply(process.env.INPATIENT_POLICY);

  robot.respond /askari insurance portal/i, (msg) -> 
    msg.reply(process.env.ASKARI_INSURANCE_PORTAL);

  robot.respond /employee handbook/i, (msg) -> 
    msg.reply(process.env.EMPLOYEE_HANDBOOK);

  robot.respond /acc reimb form|accessories reimbursement form/i, (msg) -> 
    msg.reply(process.env.ACCESSORIES_REIMBURSEMENT_FORM);
  
  