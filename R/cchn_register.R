#' Notifications: register your email address and get a token
#'
#' @export
#' @param email (character) email address to use for interaction with 
#' the CRAN checks API
#' @param ... Curl options passed to [crul::verb-GET]
#' @return list, with `email` and `token` slots
#' @details After running this function successfully (no errors), save your
#' token in your .Renviron, .bash_profile, or similar. 
#' 
#' We cache a file with details at the path 
#' `file.path(rappdirs::user_data_dir("cranchecks", "cchecks"), "emails.csv")`
cchn_register <- function(email, ...) {
  assert(email, "character")
  stopifnot("email must be length 1" = length(email) == 1)
  # create cache file if it does not exist
  file <- email_file_path()
  if (!file.exists(file)) {
    parent <- dirname(file)
    if (!file.exists(parent)) dir.create(parent, recursive = TRUE)
    toks <- data.frame(V1 = character(), V2 = character(),
      stringsAsFactors = FALSE)
  } else {
    toks <- utils::read.csv(file, stringsAsFactors = FALSE, header = FALSE)
  }
  # is token already cached for given email?
  if (email %in% toks[, 1]) {
    token <- toks[which(email == toks[,1]), 2]
    message("email '", email, "' already registered; token: ", token)
    list(email = email, token = token)
  } else {
    # not cached, new token flow
    token <- request_token(email, ...)
    toks <- rbind(toks, c(email, token))
    utils::write.table(toks, file = file, sep = ",", col.names = FALSE,
      row.names = FALSE)
    list(email = email, token = token)
  }
}

email_file_path <- function() {
  file.path(rappdirs::user_data_dir("cranchecks", "cchecks"),
    "emails.csv")
}

request_token <- function(email, ...) {
  args <- ct(list(email = email))
  res <- ccc_GET("notifications/token", args, ...)
  cch_parse(res, TRUE)$token
}
