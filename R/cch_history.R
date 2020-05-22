#' Get historical check data for packages
#'
#' @export
#' @param date (character) a date of the form `YYYY-MM-DD`. required
#' @param ... Curl options passed to [crul::verb-GET]
#' @return a tibble with columns:
#' 
#' - package: character vector of package names
#' - summary: character vector of JSON hash's of check summary data
#' - checks: character vector of JSON hash's of checks performed
#' - check_details: character vector of check details. if no check 
#' details the string will be "null"; if details given, then 
#' a JSON hash of details
#' - date_updated: character vector of dates, the date the check was
#' performed on
#' 
#' @seealso [cch_pkgs_history()]
#' @details This function gets historical data for all packages for a single
#' day; see [cch_pkgs_history()] for last 30 days history for particular
#' packages
#' 
#' You have to do a bit of data wrangling to get this data into a
#' easily sortable/filterable/etc. form
#' @examples \dontrun{
#' x <- cch_history(date = "2020-04-01")
#' str(x)
#' lapply(x$summary[1:3], jsonlite::fromJSON)
#' }
cch_history <- function(date, ...) {
  assert(date, "character")
  path <- file.path("history", date)
  tmp <- ccc_GET_link(path, ...)
  z <- crul::HttpClient$new(tmp)$get(disk = hist_file(date))
  f <- file(z$content)
  on.exit(unlink(z$content), add = TRUE)
  df <- suppressWarnings(jsonlite::stream_in(f))
  tibble::as_tibble(df)
}

hist_file <- function(date) file.path(tempdir(), date)
