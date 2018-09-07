library("httr")

#' Connect to a mlrMBO-as-a-service webserver.
#'
#' @param hostname The server to connect to. Can start with either "http://" or "https://".
#'
#' @return A handle, which can be passed to the other functions.
#' @export
mboServiceConnect = function(hostname) {
  url = sprintf("%s/session/open", hostname)
  result = httr::GET(url)
  assertthat::are_equal(httr::http_status(result)$category, "Success")
  session_id = trimws(httr::content(result, as = "text", encoding="utf8"))
  obj = list(
    hostname = hostname,
    session_id = session_id
  )
  class(obj) = append(class(obj), "mboServiceHandle")
  return(obj)
}