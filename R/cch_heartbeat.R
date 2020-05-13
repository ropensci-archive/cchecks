#' Get heartbeat
#'
#' @export
#' @param ... Curl options passed to [crul::HttpClient()]
#' @return list of routes
#' @examples \dontrun{
#' cch_heartbeat()
#' }
cch_heartbeat <- function(...) {
  x <- ccc_GET("heartbeat", args = NULL, email = NULL, no_token = TRUE, ...)
  cch_parse(x, TRUE)
}
