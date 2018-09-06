library("httr")

mboServicePropose = function(obj) {
  url = sprintf("%s/propose/%s", obj$hostname, obj$session_id)
  result = httr::GET(url)
  point = httr::content(result)
}