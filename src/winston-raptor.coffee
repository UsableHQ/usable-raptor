###
winston-raptor

This is a wrapper for winston

###
FIND_NAME = 'logging.config.yaml'

winston = require 'winston'

##enable fancyconsole
require('./winston-fancyconsole').Fancyconsole

##need this for processing stuff
require 'js-yaml'

###
remove default console
###

winston.remove winston.transports.Console
#console.log winston.loggers
###
YAML Processing and finding
###

fs = require 'fs'


init = () ->
    config_filename = process.env.NODE_YAML_LOGCONFIG ? find_config_file()
    if config_filename?
      try
        cfgObject = require(config_filename).shift()
        cfg(cfgObject)
      catch e
        # if we cant load for whatever reason use defualts, log error but keep running 
        cfg(defaults)
        use("SYS").error("Winston config `logging.config.yaml` could not be processed using defaults")
    else
      cfg(defaults)
      use("SYS").warn("Winston config `logging.config.yaml` not found using defaults")

    use("INF").info("Winston Ready")

# find the filename
find_config_file = () ->
  if process.env.NODE_YAML_LOG_CONFIG
    yaml_filename = process.env.NODE_YAML_LOG_CONFIG
    try
      stats = fs.statSync yaml_filename
      if not stats.isFile()
        throw new Error("No dice I'm afraid!")
    catch error
      console.log "No configuration file at " + yaml_filename
      process.exit(1)
  else
    directory = __dirname
    finished = false
    until finished
      yaml_filename = directory + '/' + FIND_NAME
      try
        stats = fs.statSync yaml_filename
        if stats.isFile()
          break
      if directory is '/'
        # console.log "WARNING! -- Couldn't find '#{FIND_NAME}' recursively" +
        #             " to '/' from '#{__dirname}' defaults loaded"
        return undefined
      directory = fs.realpathSync(directory + '/..')
  return yaml_filename


###
Setup winston with categories
###
cfg = (opts) ->
    processCategory option for option in opts


processCategory = (option)->
    winston.loggers.add option.name, processOption option
    winston.loggers.get(option.name).remove winston.transports.Console #remove default console

processOption = (option) ->
    #console.log(option.fancymeta)
    cfg =
        fancyconsole:
            colorize: true
            timestamp: true
            level: option.level
            category: option.name
            catcolor: option.catcolor
            fancymeta: option.fancymeta
        #console:
        #    colorize: true
        #    timestamp: true
        #   level: option.level
    
    if (option.logglySecret? and option.logglySubdomain?)
        cfg.loggly=
            level:option.level
            subdomain: option.logglySubdomain
            inputToken: option.logglySecret   
    return cfg
###
return the log object for a particular category
###
exports.use  = use = (category) ->
    return winston.loggers.get(category)

###
Decorate somthing with some category
###
exports.decorate = (obj,category) ->
    exports.use(category).extend(obj) 


defaults = [
  {
    "catcolor": "green", 
    "level": "silly", 
    "fancymeta": false, 
    "name": "INF"
  }, 
  {
    "catcolor": "bold blue", 
    "level": "silly", 
    "fancymeta": false, 
    "name": "DBG"
  }, 
  {
    "catcolor": "bold red", 
    "name": "SYS", 
    "level": "silly", 
    "fancymeta": false, 
  }, 
  {
    "catcolor": "bold white", 
    "name": "API", 
    "level": "silly", 
    "fancymeta": false, 
  }
]

###
start with default config
###

init()
