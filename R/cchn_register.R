#' Notifications: register your email address and get a token
#'
#' @export
#' @param email (character) email address to use for interaction with
#' the CRAN checks API. If no email address is given, we go through a few
#' steps: check for the cached file mentioned below for any emails; use
#' [whoami::email_address()]; if the location you are running this in is
#' a package, we look for the maintainer's email address in the package.
#' @param token (character) your CRAN checks API token. you shouldn't need
#' to pass a token here. if you used [cchn_register()] your token should
#' be cached
#' @param ... Curl options passed to [crul::verb-GET]
#' @return `NULL` - nothing returned
#' @details We cache a file with details at the path
#' `file.path(rappdirs::user_data_dir("cranchecks", "cchecks"), "emails.csv")`
cchn_register <- function(email = NULL, token = NULL, ...) {
  if (is.null(email) || is.null(token)) {
    if (!interactive()) {
      stop("No email or no token and not in interactive mode")
    }
    return(interactive_validate_email(email, token, ...))
  } else {
    valid_email(email)
  }
  add_token(email, token)
  message("Token added for ", sQuote(email))
  cat("\n")
}
