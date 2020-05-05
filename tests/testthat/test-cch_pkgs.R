test_that("cch_pkgs fails well", {
  vcr::use_cassette("cch_pkgs_error", {
    expect_error(cch_pkgs(limit = "foo"), "limit is not an integer")
    expect_error(cch_pkgs(offset = "bar"), "offset is not an integer")
    expect_error(cch_pkgs(x = "aaaaaaaaaaa"), "no results found")
  })
})

test_that("cch_pkgs", {
  vcr::use_cassette("cch_pkgs_one_pkg", {
    aa <- cch_pkgs("worrms")
  })

  expect_is(aa, "list")
  expect_named(aa)
  expect_null(aa$error)
  expect_is(aa$data, "list")
  expect_equal(aa$data$package, "worrms")
  expect_is(aa$data$summary, "list")
  expect_is(aa$data$summary$any, "logical")
  expect_is(aa$data$checks, "data.frame")
  expect_match(aa$data$date_updated, "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}")

  vcr::use_cassette("cch_pkgs_all_pkgs", {
    cc <- cch_pkgs()
  })

  expect_is(cc, "list")
  expect_named(cc)
  expect_is(cc$data, "data.frame")
  expect_is(cc$found, "integer")
  expect_is(cc$count, "integer")
  expect_is(cc$offset, "integer")
  expect_null(cc$error)
  expect_named(cc$data)
})

# FIXME: async can't be mocked/vcr right now
# vcr::use_cassette("cch_pkgs_many_pkgs", {
#   bb <- cch_pkgs(c("worrms", "taxize", "charlatan", "rgbif"))
# })
# expect_is(bb, "list")
# expect_named(bb, NULL)
# expect_equal(length(bb), 4)
# expect_null(bb[[2]]$error)
# expect_is(bb[[2]]$data, "list")
# expect_equal(bb[[2]]$data$package, "taxize")
# expect_is(bb[[2]]$data$summary, "list")
# expect_is(bb[[2]]$data$summary$any, "logical")
# expect_is(bb[[2]]$data$checks, "data.frame")
# expect_match(bb[[2]]$data$date_updated, "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}")
