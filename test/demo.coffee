raptor = require('../src/winston-raptor');

f = 
  silly: 0
  verbose: 1
  info: 2
  warn: 3
  debug: 4
  error: 5

console.log("\nraptor demo\n")

raptor.use("INF").silly "silly"
raptor.use("INF").verbose "verbose"
raptor.use("INF").info "info"
raptor.use("INF").warn "warn"
raptor.use("INF").debug "debug"
raptor.use("INF").error "error"
raptor.use("DBG").debug "this is a debug debug"
raptor.use("DBG").warn "this is a debug warning"
raptor.use("API").error "API error"
# bug in winston here?
raptor.use("SYS").error "This is an error", f
raptor.use("SYS").error "This is an error", f, null
raptor.use("SYS").log "error", "This is an error", f
raptor.use("TTS").info "New sign-up detected"
