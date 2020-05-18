rule_get <- function(id, email, ...) {
  valid_email(email)
  email_token_check(email)
  assert(id, c('integer', 'numeric'))
  if (!length(id) > 0) stop("id length can not be 0", call. = FALSE)
  x <- ccc_GET(path = file.path("notifications/rules", id), list(),
    email = email, ...)
  cch_parse(x, TRUE)
}
#' @export
#' @rdname cchn_rules
cchn_pkg_rule_get <- function(id, email = NULL, path = ".", ...) {
  check_within_a_pkg(path)
  if (is.null(email)) email <- get_maintainer_email(path)
  rule_get(id, email, ...)
}
#' @export
#' @rdname cchn_rules
cchn_rule_get <- function(id, email = NULL, quiet = FALSE, ...) {
  if (is.null(email)) email <- get_email(quiet = quiet)
  rule_get(id, email, ...)
}
