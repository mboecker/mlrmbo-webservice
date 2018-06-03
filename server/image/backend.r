library(later)

SESSION.TIMEOUT = 120 # Timeout in seconds

generateSessionKey = function() {
  return(as.integer(runif(1L, 0L, 10000L)))
}

registerSession = function(session.key) {
  run_now()
  timeout = Sys.time() + SESSION.TIMEOUT
  later::later(~destroySession(session.key), SESSION.TIMEOUT)
  cat(sprintf("Starting new session with key %i, which will timeout %s.\n", session.key, timeout))
}

destroySession = function(session.key) {
  run_now()
  cat(sprintf("Destroying session %i.\n", session.key))
}