#' Search historical package check data
#'
#' @export
#' @param q (character) full text query string
#' @param package (character) a package name. limit results to a single
#' package, e.g, `package="taxize"`
#' @param one_each (logical) if `TRUE`, return a single result for each package;
#' useful if you want to find out what packages match a particular query, and
#' don't care which day that match happened. default: `FALSE`
#' @param fields (character) vector of fields to return, e.g.,
#' `fields=c("package", "check_details")`
#' @inheritParams cch_pkgs
#' @return list of info about a package(s)
#' @examples \dontrun{
#' x <- cch_pkgs_search(q = "memory")
#' x
#' x$data
#' x$data$package
#' x$data
#' x$data$summary
#' x$data$summary$any
#' x$data$check_details
#' 
#' # restrict returned fields
#' res <- cch_pkgs_search("memory", fields = c("package", "check_details"))
#' res$data$check_details$output[1]
#' grepl('memory', res$data$check_details$output[1])
#' 
#' # one each, one record per package
#' res <- cch_pkgs_search("memory", one_each = TRUE,
#'   fields = c("package", "date_updated"))
#' res
#' 
#' # pagination
#' cch_pkgs_search("memory", limit = 3)
#' cch_pkgs_search("memory", limit = 3, offset = 4)
#' }
cch_pkgs_search <- function(q, package = NULL, one_each = FALSE,
  fields = NULL, limit = 30, offset = 0, ...) {

  if (!is.null(fields)) fields <- paste0(fields, collapse=",")
  args <- ct(list(q = q, package = package, one_each = one_each,
    fields = fields, limit = limit, offset = offset))
  res <- ccc_GET("search", args, email = NULL, no_token = TRUE, ...)
  tmp <- cch_parse(res, TRUE)
  tmp$data <- tibble::as_tibble(tmp$data)
  return(tmp)
}
