library("httr")

#' Request a point proposal from the mlrMBO-as-a-service webserver.
#'
#' @param obj The handle object created by mboServiceConnect.
#'
#' @return A vector containing the X-values of an interesting point.
#' @export
mboServicePropose = function(obj) {
  url = sprintf("%s/propose/%s", obj$hostname, obj$session_id)
  result = httr::GET(url)
  assertthat::are_equal(httr::http_status(result)$category, "Success")
  point = httr::content(result)
  return(point)
}