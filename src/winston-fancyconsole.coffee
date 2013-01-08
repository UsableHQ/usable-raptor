###
custom fancy console optimed for console debugging
###

winston = require 'winston'
common = require 'winston/lib/winston/common'
config = require 'winston/lib/winston/config'
util = require 'util'
colors = require 'colors'



Fancyconsole = exports.Fancyconsole =  (options) ->
  options = options or {};
  this.name = 'fancyconsole'
  this.level = options.level ? 'info'
  this.category = "["+options.category+"]"
  this.catcolor = options.catcolor ? ""
  this.fancymeta = options.fancymeta ? true

###
Inherit from `winston.Transport`.
###
util.inherits(Fancyconsole, winston.Transport);
###
Expose the name of this Transport on the prototype
###
winston.transports.Fancyconsole = Fancyconsole;

###
Logging
###
Fancyconsole.prototype.log = (level, msg, meta, callback) -> 
  if (this.silent)
    return callback(null, true);
  

  self = this
  
  head =      common.timestamp()
  head += " - "+colorizeGeneric(self.category,self.catcolor)
  head += " "+config.colorize(level)+ " "


  output = head + msg
  if (meta)
    if (typeof meta != 'object')
      output += ' ' + meta;
    else if (Object.keys(meta).length > 0) 
      if(self.fancymeta)
        output += '\n' + util.inspect(meta,false,null,true)
      else
        output += ' '+common.serialize(meta)

    

  if level == 'error' or level == 'debug'
    util.error(output);
  else
    util.puts(output);
  
  
  self.emit 'logged'
  callback null,true

colorizeGeneric = (text,colorList) ->
  out = text
  for color in colorList.split(" ")
    out = out[color] ? out #just drop any incorrect colours
  return out
