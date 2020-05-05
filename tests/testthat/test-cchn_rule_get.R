email <- "sckott7@gmail.com"

test_that("cchn_rule_get fails well", {
  skip_on_ci()

  expect_error(cchn_rule_get(email = email), "missing")
  expect_error(cchn_rule_get("asdasdf", email = email), "class")
})

test_that("cchn_rule_get", {
  skip_on_ci()

  # rule not found
  vcr::use_cassette("cchn_rule_get_not_found", {
    expect_error(cchn_rule_get(id = 578999, email = email),
      "not found")
  })

  # add a rule
  vcr::use_cassette("cchn_rule_get_add_rule", {
    cchn_rule_add(status = "warn", package = "honeybadger", time = 6,
      email = email, quiet = TRUE)
  })

  # after a rule added
  vcr::use_cassette("cchn_rule_get_one_rule", {
    rules <- cchn_rule_list(email = email)
    rule <- cchn_rule_get(rules$data$id[1], email = email)
  })
  expect_is(rule, "list")
  expect_named(rule, c("error", "data"))
  expect_is(rule$data, "list")
  expect_is(rule$data$id, "integer")
  expect_is(rule$data$package, "character")
  expect_is(rule$data$rule_status, "character")
  expect_is(rule$data$rule_time, "integer")
  expect_null(rule$data$rule_platforms, "character")
  expect_null(rule$data$rule_regex, "character")
  expect_equal(rule$data$package, "honeybadger")

  # cleanup
  vcr::use_cassette("cchn_rule_get_cleanup", {
    cchn_rule_delete(rule$data$id, email = email)
  })
})
