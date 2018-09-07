library("httr")

#' Disconnect from the mlrMBO-as-a-service webserver.
#'
#' @param obj The handle object created by mboServiceConnect.
#'
#' @export
mboServiceDisconnect = function(obj) {
  url = sprintf("%s/session/close/%s", obj$hostname, obj$session_id)
  result = httr::GET(url)
  assertthat::are_equal(httr::http_status(result)$category, "Success")
}