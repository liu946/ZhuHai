# Description
#   say hehe
#
# Commands:
#   hubot do you like ???  |  what do you think of ??? |你觉得 ??? 怎么样
#
# Author:
#   Liu

module.exports = (robot) ->
  robot.respond /(do you like|what do you think of) .*/i, (msg) ->
    msg.send "呵呵~"
  robot.respond /你觉得(.*)怎么样.*/i, (msg) ->
    msg.send "你说#{msg.match[1]}? 呵呵~"
