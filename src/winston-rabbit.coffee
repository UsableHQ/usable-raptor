###
communicates with nabaztag interface
###

winston = require 'winston'
common = require 'winston/lib/winston/common'
config = require 'winston/lib/winston/config'
util = require 'util'
request = require 'request'


Rabbit = exports.Rabbit =  (options) ->
  options = options or {};
  this.name = 'rabbit'
  this.level = options.level ? 'info'
  this.url = options.url
  this.user = options.user
  this.password = options.password


###
Inherit from `winston.Transport`.
###
util.inherits(Rabbit, winston.Transport);

###
Logging
###
Rabbit.prototype.log = (level, msg, meta, callback) -> 
  # console.log arguments
  # console.log this
  # process.exit()

  msg = "...#{level}... #{msg}"

  if (this.silent)
    return callback(null, true);
  
  request.post(this.url, {
  'auth': 
    'user': this.user,
    'pass': this.password
  'form':
    'tts': msg
  },() ->
    # dont care what happened exactly only that it tried
    this.emit 'logged'
    callback null,true
  )  

