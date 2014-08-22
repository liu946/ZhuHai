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
bcmainword="blockchain|bc|tell me the blockchain\'s"
bkmainword="block|bk|tell me the block\'s"
txmainword="transaction|tx|tell me the transaction\'s"
help='''
	tell me what you want to know like this.
	
	Myname <blockchain|bc> <OPTION>

	OPTION should be the following.

    *getdifficulty* - Current difficulty target as a decimal number
    *getblockcount* - Current block height in the longest chain
    *latesthash* - Hash of the latest block
    *bcperblock* - Current block reward in BTC
    *totalbc* - Total Bitcoins in circulation (delayed by up to 1 hour])
    *probability* - Probability of finding a valid block each hash attempt
    *hashestowin* - Average number of hash attempts needed to solve a block
    *nextretarget* - Block height of the next difficulty retarget

    *avgtxsize* - Average transaction size for the past 1000 blocks. Change the number of blocks by passing an integer as the second argument e.g. avgtxsize/2000
    *avgtxvalue* - Average transaction value (1000 Default)
    *interval* - average time between blocks in seconds
    *eta* - estimated time until the next block (in seconds)
    *avgtxnumber* - Average number of transactions per block (100 Default)



'''

module.exports = (robot) ->
  robot.respond "/("+bcmainword+") ("+queryapistr+")(.*)/i", (msg) ->
    RuntimeQueryAPI msg , msg.match[2]

  robot.respond "/("+bcmainword+") (-|--)?h(elp)?(.*)/i", (msg) ->
    msg.send help

  robot.respond "/("+bkmainword+") ([a-z_]*) ((and it\'s (hash|index) is)|(hash|index)) ([0-9a-z]*)/i",(msg) ->
    msg.send "please wait!"
    msg.http("http://blockchain.info/block-index/"+msg.match[7]+"?format=json")
    .get() (err,res,body) ->
      if body=="Block Not Found"
        msg.send "Block Not Found"
      else
        str=eval('('+body+')')[msg.match[2]]
        str=str.length if msg.match[2] == "tx"
        msg.send "the block's "+msg.match[2]+" : #{str}"

  robot.respond "/("+txmainword+") ([a-z_]*) ((and it\'s (hash|index) is)|(hash|index)) ([0-9a-z]*)/i",(msg) ->
    msg.send "please wait!"
    msg.http("http://blockchain.info/tx-index/"+msg.match[7]+"?format=json")
    .get() (err,res,body) ->
      if body=="Transaction not found"
        msg.send "Transaction not found"
      else
        str=eval('('+body+')')[msg.match[2]]
        str="(JSON)"+JSON.stringify(str) if msg.match[2] == "inputs" or msg.match[2] == "out" 
        msg.send "the transaction's "+msg.match[2]+" : #{str}"


RuntimeQueryAPI = (msg,querystr)->
  msg.http("http://blockchain.info/q/"+querystr)
  .get() (err,res,body) ->
  	msg.send "#{body}"