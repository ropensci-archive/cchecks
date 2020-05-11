rule_delete <- function(id, email, ...) {
  email_token_check(email)
  assert(id, c('integer', 'numeric'))
  stopifnot("id length can not be 0" = length(id) > 0)
  x <- ccc_DELETE(path = file.path("notifications/rules", id),
    email = email, ...)
  if (x$status_code == 204) message("ok")
}
#' @export
#' @rdname cchn_rules
cchn_pkg_rule_delete <- function(id, email = NULL, path = ".", ...) {
  check_within_a_pkg(path)
  if (is.null(email)) email <- get_maintainer_email(path)
  rule_delete(id, email, ...)
}
#' @export
#' @rdname cchn_rules
cchn_rule_delete <- function(id, email = NULL, quiet = FALSE, ...) {
  if (is.null(email)) email <- get_email(quiet = quiet)
  rule_delete(id, email, ...)
}
