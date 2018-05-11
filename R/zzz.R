ct <- function(l) Filter(Negate(is.null), l)

cchecks_ua <- function() {
  versions <- c(
    paste0("r-curl/", utils::packageVersion("curl")),
    paste0("crul/", utils::packageVersion("crul")),
    sprintf("rOpenSci(cchecks/%s)", utils::packageVersion("cchecks"))
  )
  paste0(versions, collapse = " ")
}

ccc_GET <- function(path, args, ...){
  cli <- crul::HttpClient$new(
    url = file.path(ccc_base(), path),
    opts = list(useragent = cchecks_ua())
  )
  temp <- cli$get(query = args)
  err_catcher(temp)
  x <- temp$parse("UTF-8")
  return(x)
}

ccc_asyncGET <- function(path, args, ...) {
  path <- file.path(ccc_base(), path)
  reqs <- lapply(path, function(z) {
    crul::HttpRequest$new(url = z, opts = list(useragent = cchecks_ua())
      )$get(query = args)
  })
  out <- AsyncVaried$new(.list = reqs)
  out$request()
  out$parse("UTF-8")
}

err_catcher <- function(x) {
  if (x$status_code > 201) {
    xx <- jsonlite::fromJSON(x$parse("UTF-8"))
    stop(sprintf("(%s) ", x$status_code), xx$error, call. = FALSE)
  }
}

cch_parse <- function(x, parse) {
  jsonlite::fromJSON(x, parse)
}

ccc_base <- function() "https://cranchecks.info"

assert <- function(x, y) {
  if (!is.null(x)) {
    if (!class(x) %in% y) {
      stop(deparse(substitute(x)), " must be of class ",
           paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}
