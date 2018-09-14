library("httr")
library("jsonlite")

#' Uploads your data to the service, such that it can be evaluated. The data is being compressed.
#'
#' @param obj The handle object created by mboServiceConnect.
#' @param data The data as a data.frame(...). The target column must be named y.
#'
#' @export
mboServiceUploadCompressed = function(obj, data) {
  assertthat::assert_that(assertthat::not_empty(data))
  assertthat::assert_that(assertthat::`%has_name%`(data, "y"))
  
  # Encode as JSON with maximum precision
  data_as_json = toJSON(as.list(data, as.character), digits = NA)
  data_as_json = charToRaw(data_as_json)
  data_as_json = brotli_compress(data_as_json, quality = 11, window = 11)
  
  url = sprintf("%s/upload_brotli/%s/%s", obj$hostname, obj$session_id, data_as_json)
  result = httr::GET(url)
  assertthat::assert_that(assertthat::are_equal(httr::http_status(result)$category, "Success"))
}