#' Get package checks data
#'
#' @export
#' @param x package name, optional, if you pass in more than one
#' we'll do async
#' @param limit number of records to return. Default: 10
#' @param offset record number to start at. Default: 0
#' @param ... Curl options passed to [crul::HttpClient()] or
#' [crul::Async()]
#' @return list of info about a package(s)
#' @note this function only gets the current days checks; see
#' [cch_pkgs_history()] for historical data
#' @examples \dontrun{
#' x <- cch_pkgs()
#' x$data
#' x$data$summary
#' x$data$checks
#' x$data$date_updated
#' x$data$package
#' x$data$url
#'
#' cch_pkgs("geojsonio")
#' cch_pkgs(c("geojsonio", "leaflet", "MASS"))
#' }
cch_pkgs <- function(x = NULL, limit = 10, offset = 0, ...) {
  assert(x, "character")
	args <- ct(list(limit = limit, offset = offset))
	path <- "pkgs"
	if (!is.null(x)) path <- file.path(path, x)
	if (length(path) > 1) {
		lapply(ccc_asyncGET(path, args), cch_parse, parse = TRUE)
	} else {
  	cch_parse(ccc_GET(path, args, email = NULL, no_token = TRUE, ...), TRUE)
	}
}
