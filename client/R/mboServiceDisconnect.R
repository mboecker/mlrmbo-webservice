library("httr")

mboServiceDisconnect = function(obj) {
  url = sprintf("%s/session/close/%s", obj$hostname, obj$session_id)
  result = httr::GET(url)
  assertthat::are_equal(httr::http_status(result)$category, "Success")
}