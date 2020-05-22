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

check_token <- function(email) {
  toks <- utils::read.csv(email_file_path(), stringsAsFactors = FALSE,
    header = FALSE)
  toks[which(email == toks[,1]), 2]
}

ccc_GET <- function(path, args, email = NULL, no_token = FALSE, ...) {
  headers <- list()
  if (!no_token) {
    token <- check_token(email)
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

ccc_GET_link <- function(path, ...) {
  cli <- crul::HttpClient$new(
    url = file.path(ccc_base(), path),
    opts = list(useragent = cchecks_ua(), followlocation = 1, ...)
  )
  temp <- cli$get()
  err_catcher(temp)
  return(temp$url)
}

ccc_DELETE <- function(path, email = NULL, ...) {
  headers <- list()
  token <- check_token(email)
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

ccc_POST <- function(path, body, email = NULL, ...) {
  headers <- list()
  token <- check_token(email)
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
    if (grepl("xml", x$response_headers$`content-type`)) {
      txt <- x$parse("UTF-8")
      if (grepl("NoSuchKey", txt) || x$status_code == 404) {
        mssg <- "error in fetching Amazon S3 file: `date` not found"
      } else {
        mssg <- "error in fetching Amazon S3 file: unknown reason"
      }
    }
    if (grepl("json", x$response_headers$`content-type`)) {
      xx <- jsonlite::fromJSON(x$parse("UTF-8"))
      mssg <- xx$error
    }
    stop(sprintf("(%s) ", x$status_code), mssg, call. = FALSE)
  }
}

cch_parse <- function(x, parse) {
  jsonlite::fromJSON(x, parse)
}
