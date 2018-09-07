library("httr")
library("jsonlite")

mboServiceUpload = function(obj, data) {
  data_as_json = toJSON(data)
  url = sprintf("%s/upload/%s/%s", obj$hostname, obj$session_id, data_as_json)
  result = httr::GET(url)
  point = httr::content(result)
}