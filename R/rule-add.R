#' @export
#' @rdname cchn_rules
cchn_rules_add <- function(rules, email, quiet = FALSE, ...) {
  if (is.null(email)) email <- get_email(quiet = quiet)
  email_token_check(email)
  assert(rules, "list")
  # check each rule
  rule_names <- c("package", "status", "time", "platforms", "regex")
  for (i in seq_along(rules)) {
    if (!inherits(rules[[i]], "list"))
      stop("each element of `rules` must be a list", call. = FALSE)
    if (!all(names(rules[[i]]) %in% rule_names)) {
      stop("one or more names in the list not in acceptable set: ",
        paste0(rule_names, collapse = ", "),
        call. = FALSE)
    }
  }
  ccc_POST("notifications/rules", body = rules, email = email, ...)
  if (!quiet) {
    for (i in seq_along(rules)) {
      mssg2(rules[[i]]$package, rule = jsonlite::toJSON(rules[[i]],
        auto_unbox = TRUE))
      cat("\n")
    }
    mssg_get_rules()
  }
}
#' @export
#' @rdname cchn_rules
cchn_pkg_rule_add <- function(status = NULL, platform = NULL,
  time = NULL, regex = NULL, package = NULL, email = NULL,
  path = ".", quiet = FALSE, ...) {

  if (is.null(email)) email <- get_maintainer_email(path)
  package <- package_name(package)
  rule_add(package, status, platform, time, regex, email, quiet, ...)
}
#' @export
#' @rdname cchn_rules
cchn_rule_add <- function(package, status = NULL, platform = NULL,
  time = NULL, regex = NULL, email = NULL, quiet = FALSE, ...) {

  if (is.null(email)) email <- get_email(quiet = quiet)
  rule_add(package, status, platform, time, regex, email, quiet, ...)
}
rule_add <- function(package, status, platform, time, regex, email, quiet, ...) {
  email_token_check(email)
  assert(package, "character")
  assert(status, "character")
  assert(platform, c("numeric", "integer", "character"))
  assert(time, c("numeric", "integer"))
  assert(regex, "character")
  assert(quiet, "logical")
  body <- ct(list(package = package, status = status, platforms = platform,
    time = time, regex = regex))
  ccc_POST("notifications/rules", body = list(body), email = email, ...)
  if (!quiet) mssg(package, rule = jsonlite::toJSON(body, auto_unbox = TRUE))
  return(TRUE)
}
