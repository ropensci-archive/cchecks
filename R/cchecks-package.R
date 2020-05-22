#' @title cchecks
#' @description Client for the cranchecks.info API
#' @section Docs:
#' See <https://cranchecks.info/docs>
#' 
#' @section Historical data:
#' There's an important shortcoming of historical data. The links in the
#' historical data in the `checks` field are not date specific. If you go to a
#' link in historical data, for example for April 2nd, 2020, links in that set
#' of data link to whatever the current check data is for that package. The
#' `check_details` field is date specific though; the text is scraped from the
#' package checks page each day and stored, so you can count on that to be date
#' specific. There are sometimes links to further checks, often of compiled
#' packages on various types of checks that CRAN runs; we do not have those
#' check results - we could get them but have not take the time to sort that
#' out.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom crul HttpClient HttpRequest AsyncVaried
#' @importFrom cli symbol cat_line rule
#' @importFrom crayon yellow green yellow style
#' @importFrom utils menu
#' @importFrom whoami email_address
#' @importFrom desc desc_get_maintainer
#' @importFrom rematch re_match
#' @importFrom addressable Address
#' @name cchecks-package
#' @aliases cchecks
#' @docType package
#' @author Scott Chamberlain \email{sckott@@protonmail.com}
#' @keywords package
NULL
