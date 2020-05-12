#' Notifications: add, list, get, delete notification rules
#'
#' @name cchn_rules
#' @param status (character) a check status, one of: error, warn, note, fail
#' @param platform (character) a platform, a string to match against the
#' platform strings used by cran checks. e.g., "osx" would match any osx
#' platform check results, whereas you could limit the rule to just a single
#' specific platform by using the target platforms exact string
#' "r-oldrel-osx-x86_64"
#' @param time (integer) number of days
#' @param regex (character) a regex string
#' @param package (character) a package name. if `NULL`, we attempt to
#' get the package name from the working directory, and fail out if there's
#' not a valid package structure/package name
#' @param email (character) email address to use for interaction with
#' the CRAN checks API. we use the email address in the maintainers slot
#' of the DESCRIPTION file of your working directory. you can supply an 
#' email address instead
#' @param path (character) path to a directory containing an R package
#' @param id (integer) a rule id. note that you can not get or delete
#' rules that are not yours. required
#' @param rules (list) a list of rules. each element in the list must
#' be a named list, in which each must have a "package", and a set of
#' rules (see below)
#' @param quiet (logical) suppress messages? default: `FALSE`
#' @param ... Curl options passed to [crul::verb-GET], [crul::verb-POST], or
#' [crul::verb-DELETE]
#' 
#' @details
#' 
#' Functions prefixed with `cchn_pkg_` operate within a package 
#' directory. That is, your current working directory is an R
#' package, and is the package for which you want to handle CRAN checks 
#' notifications. These functions make sure that you are inside of 
#' an R package, and use the email address and package name based
#' on the directory you're in.
#' 
#' Functions prefixed with just `cchn_` do not operate within a package.
#' These functions do not guess package name at all, but require the user
#' to supply a package name (for those functions that require a package name);
#' and instead of guessing an email address from your package, we guess email
#' from the cached cchecks email file.
#'
#' - `cchn_pkg_rule_add()`/`cchn_rule_add()`: add a rule, one rule per
#' function call
#' - `cchn_rules_add()`: add many rules at once; no option for package context
#' - `cchn_pkg_rule_get()`/`cchn_rule_get()`: get a rule by rule id (see
#' `cchn_pkg_rule_list()`/`cchn_rule_list()` to get ids; can only get rules for
#' the authenticated user)
#' - `cchn_pkg_rule_list()`/`cchn_rule_list()`: list all rules for the
#' authenticated user
#' - `cchn_pkg_rule_delete()`/`cchn_rule_delete()`: delete a rule by rule id
#' (only those for the authenticated user)
#' 
#' @section example rules:
#' 
#' - ERROR for 3 days in a row across 2 or more platforms
#'     - `cchn_rule_add(status = 'error', time = 3, platform = 2)`
#' - ERROR for 2 days in a row on all osx platforms
#'     - `cchn_rule_add(status = 'error', time = 2, platform = "osx")`
#' - ERROR for 2 days in a row on all release R versions
#'     - `cchn_rule_add(status = 'error', time = 2, platform = "release")`
#' - WARN for 4 days in a row on any platform except Solaris
#'     - `cchn_rule_add(status = 'warn', time = 4, platform = "-solaris")`
#' - WARN for 2 days in a row across 9 or more platforms
#'     - `cchn_rule_add(status = 'warn', time = 2, platform = 10)`
#' - NOTE across all osx platforms
#'     - `cchn_rule_add(status = 'note', platform = "osx")`
#' - NOTE
#'     - `cchn_rule_add(status = 'note')`
#' - error details contain regex 'install'
#'     - `cchn_rule_add(regex = "install")`
#' 
#' @return 
#' 
#' - `cchn_pkg_rule_add()`/`cchn_rule_add()`/`cchn_rules_add()`: message about
#' the rule added, and a note about using `cchn_rule_list()` to list your rules
#' - `cchn_pkg_rule_get()`/`cchn_rule_get()`: list with elements `error` and
#' `data` (a list of the parts of the rule)
#' - `cchn_pkg_rule_list()`/`cchn_rule_list()`: list with elements `error` and
#' `data` (a data.frame of all the rules associated with your email)
#' - `cchn_pkg_rule_delete()`/`cchn_rule_delete()`: if deletion works, a
#' message saying "ok"
#'
#' @examples \dontrun{
#' ## Workflow 1: within a package directory
#' # (x <- cchn_pkg_rule_list())
#' # if (length(x$data$id) > 0) {
#' #  cchn_pkg_rule_get(x$data$id[1])
#' #  cchn_pkg_rule_delete(x$data$id[1])
#' #  cchn_pkg_rule_get(id = x$data$id[1])
#' # }
#' 
#' ## Workflow 2: not in a package directory
#' # (x <- cchn_rule_list())
#' # if (length(x$data$id) > 0) {
#' #  cchn_rule_get(x$data$id[1])
#' #  cchn_rule_delete(x$data$id[1])
#' #  cchn_rule_get(id = x$data$id[1])
#' # }
#' 
#' ## cchn_pkg_rule_add: add a rule - guesses the package name
#' ## you can specify the package name instead
#' # cchn_pkg_rule_add(status = "note", platform = 3,
#' #  email = "some-email")
#' ## cchn_rule_add: add a rule - not in package context, must 
#' ## specify the package name
#' # cchn_rule_add(package = "foobar", status = "note", platform = 3,
#' #  email = "some-email")
#' 
#' ## cchn_pkg_rule_add: should guess package name and email
#' # cchn_pkg_rule_add(status = "note", platform = 3)
#' 
#' ## cchn_rule_add: package name must be supplied. takes first email
#' ## from cached emails.csv file, see `?cchn_register` for more
#' # cchn_rule_add(package = "foobar", status = "warn", platform = 2)
#' 
#' ## cchn_rules_add: add many rules at once
#' ## no package context here, email and package names must be given
#' # pkg <- "charlatan"
#' # rules <- list(
#' #   list(package = pkg, status = "warn"),
#' #   list(package = pkg, status = "error", time = 4)
#' # )
#' # cchn_rules_add(rules, "your-email", verbose = TRUE)
#' }
NULL
