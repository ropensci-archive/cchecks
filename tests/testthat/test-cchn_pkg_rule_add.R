email <- "sckott7@gmail.com"

testthat::setup({
  options(usethis.quiet=TRUE) # quiet usethis
})
testthat::teardown({
  options(usethis.quiet=FALSE)
})

test_that("cchn_pkg_rule_add", {
  skip_on_ci()

  path <- fake_pkg("bubbles")
  on.exit(unlink(path, recursive = TRUE), add = TRUE)

  vcr::use_cassette("cchn_pkg_rule_add", {
    x <- cchn_pkg_rule_add(status = "note", platform = 3,
      quiet = TRUE, path = path)
    rules <- cchn_pkg_rule_list(path = path)
  })
  
  expect_true(x)

  dat <- rules$data
  fb <- dat[dat$package == "bubbles", ]
  expect_equal(sort(names(fb)),
    c("id", "package", "rule_platforms", "rule_regex",
      "rule_status", "rule_time"))
  expect_equal(fb$package, "bubbles")

  # cleanup
  vcr::use_cassette("cchn_pkg_rule_add_cleanup", {
    cchn_pkg_rule_delete(fb$id, path = path)
  })
})
