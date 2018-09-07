library("httr")

mboServiceSetConfigKeyRaw = function(obj, key, value) {
  url = sprintf("%s/set/%s/%s/%s", obj$hostname, obj$session_id, key, value)
  result = httr::GET(url)
  assertthat::are_equal(httr::http_status(result)$category, "Success")
}