email <- "sckott7@gmail.com"
pkg <- "testing123"

test_that("cchn_rule_add", {
  skip_on_ci()

  vcr::use_cassette("cchn_rule_add", {
    x <- cchn_rule_add(package = pkg, status = "warn", platform = 2,
      email = email, quiet = TRUE)
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
  expect_equal(fb$package, pkg)

  # cleanup
  vcr::use_cassette("cchn_rule_add_cleanup", {
    cchn_rule_delete(fb$id, email = email)
  })
})
