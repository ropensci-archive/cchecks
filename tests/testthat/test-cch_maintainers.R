test_that("cch_maintainers fails well", {
  vcr::use_cassette("cch_maintainers_error", {
    expect_error(cch_maintainers(limit = "foo"), "limit is not an integer")
    expect_error(cch_maintainers(offset = "bar"), "offset is not an integer")
    expect_error(cch_maintainers(x = "aaaaaaaaaaa"), "no results found")
  })
})

test_that("cch_maintainers", {
  email <- "csardi.gabor_at_gmail.com"

  vcr::use_cassette("cch_maintainers_one_maint", {
    aa <- cch_maintainers(email)
  })

  expect_is(aa, "list")
  expect_named(aa)
  expect_null(aa$error)
  expect_is(aa$data, "list")
  expect_is(aa$data$email, "character")
  expect_equal(aa$data$email, email)
  expect_is(aa$data$name, "character")
  expect_is(aa$data$url, "character")
  expect_is(aa$data$table, "data.frame")
  expect_is(aa$data$packages, "data.frame")
  expect_is(aa$data$date_updated, "character")

  vcr::use_cassette("cch_maintainers_all_maints", {
    cc <- cch_maintainers()
  })

  expect_is(cc, "list")
  expect_named(cc)
  expect_is(cc$data, "data.frame")
  expect_is(cc$data$table, "list")
  expect_is(cc$data$packages, "list")
})
