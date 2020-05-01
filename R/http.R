ccc_base <- function() "https://cranchecks.info"
# ccc_base <- function() "http://localhost:8834"

cchecks_ua <- function() {
  versions <- c(
    paste0("r-curl/", utils::packageVersion("curl")),
    paste0("crul/", utils::packageVersion("crul")),
    sprintf("rOpenSci(cchecks/%s)", utils::packageVersion("cchecks"))
  )
  paste0(versions, collapse = " ")
}

check_token <- function(x = NULL) {
  tmp <- if (is.null(x)) Sys.getenv("CCHECKS_API_KEY", "") else x
  if (tmp == "") 
    stop("you need an API token for CRAN checks notifications",
      call. = FALSE)
  return(tmp)
}

ccc_GET <- function(path, args, token = NULL, ...) {
  headers <- list()
  token <- check_token(token)
  if (!is.null(token)) {
    headers <- list(Authorization = paste("Bearer", token))
  }
  cli <- crul::HttpClient$new(
    url = file.path(ccc_base(), path),
    opts = list(useragent = cchecks_ua(), ...),
    headers = headers
  )
  temp <- cli$get(query = args)
  err_catcher(temp)
  x <- temp$parse("UTF-8")
  return(x)
}

ccc_DELETE <- function(path, token = NULL, ...) {
  headers <- list()
  token <- check_token(token)
  if (!is.null(token)) {
    headers <- list(Authorization = paste("Bearer", token))
  }
  cli <- crul::HttpClient$new(
    url = file.path(ccc_base(), path),
    opts = list(useragent = cchecks_ua(), ...),
    headers = headers
  )
  temp <- cli$delete()
  err_catcher(temp)
  return(temp)
}

ccc_POST <- function(path, body, token = NULL, ...) {
  headers <- list()
  token <- check_token(token)
  if (!is.null(token)) {
    headers <- list(Authorization = paste("Bearer", token))
  }
  cli <- crul::HttpClient$new(
    url = file.path(ccc_base(), path),
    opts = list(useragent = cchecks_ua(), ...),
    headers = c(headers, `Content-Type` = "application/json")
  )
  temp <- cli$post(body = body, encode = "json")
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
    if (x$status_code == 204) return(NULL)
    xx <- jsonlite::fromJSON(x$parse("UTF-8"))
    stop(sprintf("(%s) ", x$status_code), xx$error, call. = FALSE)
  }
}

cch_parse <- function(x, parse) {
  jsonlite::fromJSON(x, parse)
}
