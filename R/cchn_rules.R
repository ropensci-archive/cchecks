#' Notifications: add, list, get, delete notification rules
#'
#' @name cchn_rules
#' @param package (character) a package name. required
#' @param status (character) a check status, one of: error, warn, note, fail
#' @param platform (character) a platform, a string to match against the
#' platform strings used by cran checks. e.g., "osx" would match any osx
#' platform check results, whereas you could limit the rule to just a single
#' specific platform by using the target platforms exact string
#' "r-oldrel-osx-x86_64"
#' @param time (character) number of days
#' @param regex  (character) a regex string
#' @param id (integer) a rule id. note that you can not get or delete
#' rules that are not yours. required
#' @param token (character) your CRAN checks API token. ideally you do not
#' pass in your token as a parameter, but rather store as a env var
#' @param ... Curl options passed to [crul::verb-GET]
#' @return list
#' @details 
#' 
#' - `cchn_rule_add()`: add a rule, one rule per function call
#' - `cchn_rule_get()`: get a rule by rule id (see `cchn_rule_list` to get ids;
#' can only get rules for the authenticated user)
#' - `cchn_rule_list()`: list all rules for the authenticated user
#' - `cchn_rule_delete()`: delete a rule by rule id (only those for the
#' authenticated user)
#' 
#' @examples \dontrun{
#' # (x <- cchn_rule_list())
#' # cchn_rule_get(x$data$id[1])
#' # cchn_rule_delete(x$data$id[1])
#' # cchn_rule_get(id = x$data$id[1])
#' }

#' @export
#' @rdname cchn_rules
cchn_rule_add <- function(package, status = NULL, platform = NULL, time = NULL,
  regex = NULL, token = NULL, ...) {

  assert(package, "character")
  assert(status, "character")
  assert(platform, "character")
  assert(time, c("numeric", "integer"))
  assert(regex, "character")
  body <- ct(list(package = package, status = status, platforms = platform,
    time = time, regex = regex))
  x <- ccc_POST("notifications/rules", body = list(body), ...)
  cch_parse(x, TRUE)
}

#' @export
#' @rdname cchn_rules
cchn_rule_list <- function(token = NULL, ...) {
  x <- ccc_GET(path = "notifications/rules", list(), token, ...)
  cch_parse(x, TRUE)
}

#' @export
#' @rdname cchn_rules
cchn_rule_get <- function(id, token = NULL, ...) {
  assert(id, c('integer', 'numeric'))
  stopifnot("id length can not be 0" = length(id) > 0)
  x <- ccc_GET(path = file.path("notifications/rules", id), list(), token, ...)
  cch_parse(x, TRUE)
}

#' @export
#' @rdname cchn_rules
cchn_rule_delete <- function(id, token = NULL, ...) {
  assert(id, c('integer', 'numeric'))
  stopifnot("id length can not be 0" = length(id) > 0)
  x <- ccc_DELETE(path = file.path("notifications/rules", id), token, ...)
  if (x$status_code == 204) message("ok")
}
