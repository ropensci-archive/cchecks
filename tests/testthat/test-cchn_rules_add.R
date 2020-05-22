email <- "sckott7@gmail.com"
pkg <- "testing456"

test_that("cchn_rules_add", {
  skip_on_ci()

  rlz <- list(
    list(package = pkg, status = "warn"),
    list(package = pkg, status = "error", time = 4)
  )

  vcr::use_cassette("cchn_rules_add", {
    x <- cchn_rules_add(rules = rlz, email = email, quiet = TRUE)
    rules <- cchn_rule_list(email = email)
  })
  
  expect_is(x, "list")
  expect_named(x, c("error","data"))
  expect_null(x$error)
  expect_is(x$data, "data.frame")
  expect_is(x$data$id, "integer")
  expect_is(x$data$already_existed, "logical")
  expect_is(x$data$rule, "character")

  dat <- rules$data
  fb <- dat[dat$package == pkg, ]
  expect_equal(sort(names(fb)),
    c("id", "package", "rule_platforms", "rule_regex",
      "rule_status", "rule_time"))
  expect_equal(unique(fb$package), pkg)

  # cleanup
  vcr::use_cassette("cchn_rules_add_cleanup", {
    lapply(fb$id, cchn_rule_delete, email = email)
  })
})

test_that("cchn_rules_add fails well", {
  # missing rules param
  expect_error(cchn_rules_add(), "missing")
  # missing email param
  expect_error(cchn_rules_add(4), "missing")
  # rules wrong type
  expect_error(cchn_rules_add(4, email), "class list")
  # rules each element must be a list
  expect_error(cchn_rules_add(list(4, 5), email), "a list")
  # rules each element must be a named list, with names in acceptable set
  expect_error(cchn_rules_add(list(list(foo ="bar")), email),
    "one or more names")
})
