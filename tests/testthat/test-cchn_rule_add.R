email <- "sckott7@gmail.com"
pkg <- "testing123"

test_that("cchn_rule_add", {
  skip_on_ci()

  vcr::use_cassette("cchn_rule_add", {
    x <- cchn_rule_add(package = pkg, status = "warn", platform = 2,
      email = email, quiet = TRUE)
    rules <- cchn_rule_list(email = email)
  })
  
  expect_true(x)

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
