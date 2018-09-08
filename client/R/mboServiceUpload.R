library("httr")
library("jsonlite")

#' Uploads your data to the service, such that it can be evaluated.
#'
#' @param obj The handle object created by mboServiceConnect.
#' @param data The data as a data.frame(...). The target column should be named y.
#'
#' @export
mboServiceUpload = function(obj, data) {
  data_as_json = toJSON(as.list(data))
  url = sprintf("%s/upload/%s/%s", obj$hostname, obj$session_id, data_as_json)
  result = httr::GET(url)
  assertthat::assert_that(assertthat::are_equal(httr::http_status(result)$category, "Success"))
}