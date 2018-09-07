library("httr")

mboServiceConnect = function(hostname) {
  url = sprintf("%s/session/open", hostname)
  result = httr::GET(url)
  session_id = trimws(httr::content(result, as = "text", encoding="utf8"))
  obj = list(
    hostname = hostname,
    session_id = session_id
  )
  class(obj) = append(class(obj), "mboServiceHandle")
  return(obj)
}