# Description:
#   Some expanding function to hubot in blockchain
#
# Dependencies:
#   
#
# Configuration:
#   None
#
# Commands:
#   
#
# Author:
#   Liu

http = require('http')

queryapistr="getdifficulty|getblockcount|latesthash|bcperblock|totalbc|probability|hashestowin|nextretarget|avgtxsize|avgtxvalue|interval|eta|avgtxnumber"

help='''
	tell me what you want to know like this.
	Myname <blockchain|bc> <OPTION>

	OPTION should be the following.
	
    getdifficulty - Current difficulty target as a decimal number
    getblockcount - Current block height in the longest chain
    latesthash - Hash of the latest block
    bcperblock - Current block reward in BTC
    totalbc - Total Bitcoins in circulation (delayed by up to 1 hour])
    probability - Probability of finding a valid block each hash attempt
    hashestowin - Average number of hash attempts needed to solve a block
    nextretarget - Block height of the next difficulty retarget

    avgtxsize - Average transaction size for the past 1000 blocks. Change the number of blocks by passing an integer as the second argument e.g. avgtxsize/2000
    avgtxvalue - Average transaction value (1000 Default)
    interval - average time between blocks in seconds
    eta - estimated time until the next block (in seconds)
    avgtxnumber - Average number of transactions per block (100 Default)

'''

module.exports = (robot) ->
  robot.respond "/(blockchain|bc) ("+queryapistr+")(.*)/i", (msg) ->
    RuntimeQueryAPI msg , msg.match[2]
  robot.respond "/(blockchain|bc) (-|--)?help(.*)/i", (msg) ->
    msg.send help

RuntimeQueryAPI = (msg,querystr)->
  msg.http("http://blockchain.info/q/"+querystr)
  .get() (err,res,body) ->
  	msg.send "#{body}"