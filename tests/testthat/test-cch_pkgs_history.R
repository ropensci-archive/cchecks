test_that("cch_pkgs_history fails well", {
  vcr::use_cassette("cch_pkgs_history_error", {
    expect_error(cch_pkgs_history("x", limit = "foo"), "limit is not an integer")
    expect_error(cch_pkgs_history("x", offset = "bar"), "offset is not an integer")
    expect_error(cch_pkgs_history(x = "aaaaaaaaaaa"), "no results found")
  })
})

test_that("cch_pkgs_history", {
  vcr::use_cassette("cch_pkgs_history_one_pkg", {
    aa <- cch_pkgs_history("worrms")
  })

  expect_is(aa, "list")
  expect_named(aa)
  expect_null(aa$error)
  expect_is(aa$data, "list")
  expect_equal(aa$data$package, "worrms")
  expect_is(aa$data$history$summary, "data.frame")
  expect_is(aa$data$history$summary$any, "logical")
  expect_is(aa$data$history$checks, "list")
  expect_match(aa$data$history$date_updated, "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}")
})

test_that("cch_pkgs_history - many pkgs", {
  # FIXME: can't be cached - vcr can't handle async yet
  skip_on_ci()
  skip_on_cran()

  cc <- cch_pkgs_history(c("leaflet", "stringi"))
  expect_is(cc, "list")
  expect_named(cc, NULL)
  expect_null(cc$error)
  
  expect_is(cc[[1]]$data, "list")
  expect_equal(cc[[1]]$data$package, "leaflet")

  expect_is(cc[[2]]$data, "list")
  expect_equal(cc[[2]]$data$package, "stringi")
})
