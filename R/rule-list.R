# rule list
rule_list <- function(email, ...) {
  valid_email(email)
  email_token_check(email)
  x <- ccc_GET("notifications/rules", list(), email = email, ...)
  cch_parse(x, TRUE)
}
#' @export
#' @rdname cchn_rules
cchn_pkg_rule_list <- function(email = NULL, path = ".", ...) {
  check_within_a_pkg(path)
  if (is.null(email)) email <- get_maintainer_email(path)
  rule_list(email, ...)
}
#' @export
#' @rdname cchn_rules
cchn_rule_list <- function(email = NULL, quiet = FALSE, ...) {
  if (is.null(email)) email <- get_email(quiet = quiet)
  rule_list(email, ...)
}
