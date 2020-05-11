# much of the below code adapted from r-hub/rhub
add_token <- function(email, token) {
  file <- email_file_path()
  if (!file.exists(file)) {
    parent <- dirname(file)
    if (!file.exists(parent)) dir.create(parent, recursive = TRUE)
    toks <- data.frame(V1 = character(), V2 = character(),
      stringsAsFactors = FALSE)
  } else {
    toks <- utils::read.csv(file, stringsAsFactors = FALSE, header = FALSE)
  }
  if (email %in% toks[, 1]) {
    toks[which(email == toks[,1]), 2] <- token
  } else {
    toks <- rbind(toks, c(email, token))
  }
  utils::write.table(toks, file = file, sep = ",", col.names = FALSE,
    row.names = FALSE)
}

email_file_path <- function() {
  file.path(rappdirs::user_data_dir("cranchecks", "cchecks"),
    "emails.csv")
}

request_token <- function(email, ...) {
  args <- ct(list(email = email))
  ccc_GET("notifications/token", args, no_token = TRUE, ...)
}

cchn_valid <- function(token = NULL) {
  z <- tryCatch(cchn_rule_list(token = token), error = function(e) e)
  !inherits(z, "error")
}

token_registered <- function(email) {
  file <- email_file_path()
  if (file.exists(file)) {
    toks <- utils::read.csv(file, stringsAsFactors = FALSE, header = FALSE)
    if (email %in% toks[, 1]) {
      token <- toks[which(email == toks[,1]), 2]
      if (cchn_valid(token)) {
        message("email '", email, "' already registered")
        return(TRUE)
      } # if FALSE, we return FALSE below and ask for new token
    }
  }
  return(FALSE)
}

fetch_token <- function(email) {
  toks <- utils::read.csv(email_file_path(), stringsAsFactors = FALSE,
    header = FALSE)
  toks[which(email == toks[,1]), 2]
}

interactive_validate_email <- function(email, token, path = ".", ...) {
  if (is.null(email)) email <- get_email_to_validate(path)
  stopifnot("'email' is not a valid email" = grepl(".@.", email))

  if (token_registered(email)) {
    # return(list(email = email, token = fetch_token(email)))
    return(cchn_register(email, fetch_token(email)))
  }
  
  if (is.null(token)) {
    request_token(email, ...)
    message(crayon::yellow(
      "Check your emails for the CRAN checks token"
    ))
    token <- readline("Token: ")
  }
  stopifnot(grepl("[a-zA-Z0-9]{6}", token, perl = TRUE))
  cchn_register(email, token)
}

get_email_to_validate <- function(path) {
  valid <- list_validated_emails2(msg_if_empty = FALSE)
  guess <- whoami::email_address()
  maint <- tryCatch(get_maintainer_email(path), error = function(e) NULL)

  choices <- rbind(
    if (nrow(valid)) cbind(valid = TRUE, valid),
    if (!is.null(guess) && ! guess %in% valid$email) {
      tibble::tibble(valid = FALSE, email = guess, token = NA)
    },
    if (!is.null(maint) && ! maint %in% valid$email && maint != guess) {
      tibble::tibble(valid = FALSE, email = maint, token = NA)
    },
    tibble::tibble(valid = NA, email = "New email address", token = NA)
  )

  ## Only show the menu if there is more than one thing there
  if (nrow(choices) != 1) {
    choices_str <- paste(
      sep = "  ",
      ifelse(
        choices$valid & !is.na(choices$valid),
        crayon::green(symbol$tick),
        " "
      ),
      choices$email
    )

    cat("\n")
    title <- crayon::yellow(paste0(
      symbol$line, symbol$line,
      " Choose email address to (re)validate (or 0 to exit)"
    ))
    ch <- menu(choices_str, title = title)

    if (ch == 0) stop("Cancelled email validation", call. = FALSE)

  } else {
    ch <- 1
  }

  ## Get another address if that is selected
  if (is.na(choices$valid[ch])) {
    cat("\n")
    email <- readline("Email address: ")
  } else {
    email <- choices$email[ch]
  }
}

list_validated_emails2 <- function(msg_if_empty = TRUE) {
  file <- email_file_path()
  res <- if (file.exists(file)) {
    structure(
      utils::read.csv(file, stringsAsFactors = FALSE, header = FALSE),
      names = c("email", "token")
    )
  } else {
    data.frame(
      email = character(),
      token = character(),
      stringsAsFactors = FALSE
    )
  }
  if (interactive() && nrow(res) == 0) {
    if (msg_if_empty) message("No validated emails found.")
    invisible(res)
  } else {
    res
  }
}

stract <- function(str, pattern) regmatches(str, regexpr(pattern, str))

parse_email <- function(x) {
  unname(
    rematch::re_match(pattern = "<(?<email>[^>]+)>", x)[, "email"]
  )
}

get_maintainer_email <- function(path) {
  path <- normalizePath(path, mustWork = TRUE)
  if (file.info(path)$isdir) {
    if (!file.exists(file.path(path, "DESCRIPTION"))) {
      stop("No 'DESCRIPTION' file found")
    }
    parse_email(desc::desc_get_maintainer(path))
  } else {
    stop("does not appear to be a package")
  }
}

assert_validated_email_for_check <- function(email) {
  token <- email_get_token(email)
  if (is.null(token)) {
    stop(paste(collapse = "\n", strwrap(indent = 2, exdent = 2, paste(
      sQuote(crayon::green(email)), "is not validated, see ?cchn_register"
    ))))
  }
}

email_get_token <- function(email) {
  file <- email_file_path()
  if (!file.exists(file)) return(NULL)

  tokens <- utils::read.csv(file, stringsAsFactors = FALSE, header = FALSE)
  if (!email %in% tokens[,1]) return(NULL)

  tokens[match(email, tokens[,1]), 2]
}

email_token_check <- function(email = NULL, path = ".") {
  if (is.na(email)) stop("Cannot get email address from package")
  assert_validated_email_for_check(email)
}

package_name <- function(package) {
  if (is.null(package)) {
    if (!desc::desc_has_fields("Package"))
      stop("could not find package name")
    package <- desc::desc_get_field("Package")
  }
  return(package)
}

add_mssg <- function(package, rule) {
  cli::rule(
    left = "success ", line = 2, line_col = "blue", width = 30
  )
  cli::cat_line(
    paste("rule added for package", crayon::style(package, "lightblue"))
  )
  cli::cat_line(
    paste("rule:", crayon::style(rule, "purple"))
  )
  cli::cat_line("use ", crayon::style("cchn_rule_list()", "underline"),
    " to get your rules")
}
