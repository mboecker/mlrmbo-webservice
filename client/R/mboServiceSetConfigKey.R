library("httr")

mboServiceSetConfigKey = function(obj, key, value) {
  url = sprintf("%s/set/%s/%s/%s", obj$hostname, obj$session_id, key, value)
  result = httr::GET(url)
}