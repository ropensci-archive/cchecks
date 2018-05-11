#' Get heartbeat
#'
#' @export
#' @param ... Curl options passed to [crul::HttpClient()]
#' @return list of routes
#' @examples \dontrun{
#' cch_heartbeat()
#' }
cch_heartbeat <- function(...) {
  cch_parse(ccc_GET("heartbeat", NULL, ...), TRUE)
}
