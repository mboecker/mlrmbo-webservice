library("httr")

#' Change the mlrMBO settings used for your point proposal.
#' This is a internal function usable for arbitrary keys and values.
#' Use mboServiceSetConfigKey instead.
#'
#' @param obj The handle object created by mboServiceConnect.
#' @param key The config key to be set.
#' @param value The new value of the key.
mboServiceSetConfigKeyRaw = function(obj, key, value) {
  url = sprintf("%s/set/%s/%s/%s", obj$hostname, obj$session_id, key, value)
  result = httr::GET(url)
  assertthat::are_equal(httr::http_status(result)$category, "Success")
}