library("httr")

mboServiceDisconnect = function(obj) {
  url = sprintf("%s/session/close/%s", obj$hostname, obj$session_id)
  httr::GET(url)
}