source("backend.r")

#' @get /login
function() {
  session.key = generateSessionKey()
  
  registerSession(session.key)
  
  return(list(session.key = session.key))
}

#' @get /logout
function(session.key) {
  destroySession(session.key)
}

#' @get /upload_data
function(session.key, X, y) {
  if(is.vector(X)) {
    X = matrix(X, ncol = 1)
  }
  
  
}

#' @get /predict
predict <- function(session.key) {
  
}
