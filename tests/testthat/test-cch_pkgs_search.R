test_that("cch_pkgs_search fails well", {
  vcr::use_cassette("cch_pkgs_search_error", {
    expect_error(cch_pkgs_search("foo", limit = "foo"), "limit is not an integer")
    expect_error(cch_pkgs_search("foo", offset = "bar"), "offset is not an integer")
    expect_error(cch_pkgs_search("aaaaaaaaaaa"), "no results found")
  })
})

test_that("cch_pkgs_search", {
  vcr::use_cassette("cch_pkgs_search", {
    aa <- cch_pkgs_search("memory")
  })

  expect_is(aa, "list")
  expect_named(aa)
  expect_null(aa$error)
  expect_is(aa$data, "data.frame")
  expect_is(aa$data$package, "character")
  expect_is(aa$data$summary, "data.frame")
  expect_is(aa$data$summary$any, "logical")
  expect_is(aa$data$checks, "list")
  expect_match(aa$data$check_details$output[1], "memory")
  expect_match(aa$data$date_updated, "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}")

  vcr::use_cassette("cch_pkgs_search_limit_by_package", {
    cc <- cch_pkgs_search("memory", package = "apsimr")
  })

  expect_is(cc, "list")
  expect_named(cc)
  expect_is(cc$data, "data.frame")
  expect_equal(unique(cc$data$package), "apsimr")
  expect_equal(length(unique(cc$data$package)), 1)
})
