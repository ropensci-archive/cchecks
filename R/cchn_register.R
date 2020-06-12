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
#' @details We cache a file with email addresses and tokens at the path
#' `file.path(rappdirs::user_data_dir("cranchecks", "cchecks"), "emails.csv")`
#' You can run that in R to get the path for the file on your machine.
#' 
#' To get a new token for an email address that was previously registered,
#' go to the file above and delete the line with the email address and token
#' for the email address in question; remember to save the change.
#' Then when you run `cchn_register()` again for that email you can get
#' a new token.
#' 
#' To add an email address that was validated before (probably on
#' another machine), to the configuration file, call this function
#' with the ‘email’ and ‘token’ arguments.
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
