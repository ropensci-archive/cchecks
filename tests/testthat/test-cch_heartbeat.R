test_that("cch_heartbeat", {
  vcr::use_cassette("cch_heartbeat", {
    aa <- cch_heartbeat()
  })

  expect_is(aa, "list")
  expect_named(aa, "routes")
  expect_is(aa$routes, "character")
  expect_true(all(grepl("/", aa$routes)))
})
