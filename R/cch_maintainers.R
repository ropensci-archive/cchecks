#' Get maintainer based checks
#'
#' @export
#' @param x email slug name, optional, if you pass in more than one
#' we'll do async
#' @param limit number of records to return. Default: 10
#' @param offset record number to start at. Default: 0
#' @param ... Curl options passed to [crul::HttpClient()] or
#' [crul::Async()]
#' @return list of info about a package(s)
#' @examples \dontrun{
#' x <- cch_maintainers()
#' x$data
#' x$data$summary
#' x$data$checks
#' x$data$date_updated
#' x$data$package
#' x$data$url
#'
#' cch_maintainers("00gerhard_at_gmail.com")
#' cch_maintainers(c("123saga_at_gmail.com", "13268259225_at_163.com",
#' 	 "csardi.gabor_at_gmail.com"))
#' }
cch_maintainers <- function(x = NULL, limit = 10, offset = 0, ...) {
  assert(x, "character")
	args <- ct(list(limit = limit, offset = offset))
	path <- "maintainers"
	if (!is.null(x)) path <- file.path(path, x)
	if (length(path) > 1) {
		lapply(ccc_asyncGET(path, args), cch_parse, parse = TRUE)
	} else {
  	cch_parse(ccc_GET(path, args, email = NULL, no_token = TRUE, ...), TRUE)
	}
}
