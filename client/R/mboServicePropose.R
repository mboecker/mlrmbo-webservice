library("httr")

mboServicePropose = function(obj) {
  url = sprintf("%s/propose/%s", obj$hostname, obj$session_id)
  result = httr::GET(url)
  assertthat::are_equal(httr::http_status(result)$category, "Success")
  point = httr::content(result)
  return(point)
}