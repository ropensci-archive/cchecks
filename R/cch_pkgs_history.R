#' Get historical check data for packages
#'
#' @export
#' @param x package name, required, if you pass in more than one
#' we'll do async
#' @inheritParams cch_pkgs
#' @return list of info about a package(s)
#' @details this function gets historical data; for current day check data only
#' see [cch_pkgs()]
#' 
#' data is only available for 30 days prior to today's date, see the
#' `/history/:date` route for older data
#' @examples \dontrun{
#' x <- cch_pkgs_history(x = "geojsonio")
#' x
#' x$data
#' x$data$package
#' x$data$history
#' x$data$history$summary
#' x$data$history$summary$any
#' x$data$history$check_details
#' 
#' # many packages
#' res <- cch_pkgs_history(c("geojsonio", "leaflet", "MASS"))
#' res
#' 
#' # pagination
#' cch_pkgs_history(x = "geojsonio", limit = 3)
#' cch_pkgs_history(x = "geojsonio", limit = 3, offset = 4)
#' }
cch_pkgs_history <- function(x, limit = 30, offset = 0, ...) {
  args <- ct(list(limit = limit, offset = offset))
  path <- "pkgs/%s/history"
  path <- sprintf(path, x)
  if (length(path) > 1) {
    lapply(ccc_asyncGET(path, args), each_story)
  } else {
    each_story(ccc_GET(path, args, email = NULL, no_token = TRUE, ...))
  }
}

each_story <- function(x, parse = TRUE) {
  tmp <- cch_parse(x, parse)
  tmp$data$history <- tibble::as_tibble(tmp$data$history)
  return(tmp)
}
