email <- "sckott7@gmail.com"

test_that("cchn_pkg_rule_list fails well", {
  skip_on_ci()

  expect_error(cchn_pkg_rule_list())
  expect_error(cchn_pkg_rule_list("asdasdf"), "not validated")
  expect_error(cchn_pkg_rule_list(path = "asdasdf"), "No such")
})

test_that("cchn_pkg_rule_list", {
  skip_on_ci()

  # before any rules added
  vcr::use_cassette("cchn_pkg_rule_list_empty", {
    rules <- cchn_pkg_rule_list(email = email)
  })
  expect_is(rules, "list")
  expect_is(rules$data, "list")
  expect_equal(length(rules$data), 0)

  # add a rule
  vcr::use_cassette("cchn_pkg_rule_list_add_rule", {
    cchn_pkg_rule_add(status = "note", package = "wombat",
      email = email, quiet = TRUE)
  })

  # after a rule added
  vcr::use_cassette("cchn_pkg_rule_list_one_rule", {
    rules <- cchn_pkg_rule_list(email = email)
  })
  expect_is(rules, "list")
  expect_is(rules$data, "data.frame")
  expect_equal(NROW(rules$data), 1)

  # cleanup
  vcr::use_cassette("cchn_pkg_rule_list_cleanup", {
    cchn_pkg_rule_delete(rules$data$id[1], email = email)
  })
})
