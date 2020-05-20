ct <- function(l) Filter(Negate(is.null), l)

assert <- function(x, y) {
  if (!is.null(x)) {
    if (!inherits(x, y)) {
      stop(deparse(substitute(x)), " must be of class ",
        paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}

as_log <- function(x) {
  if (is.null(x)) return(x)
  if (x) "true" else "false"
}
