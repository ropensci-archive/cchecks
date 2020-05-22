test_that("cch_history fails well", {
  vcr::use_cassette("cch_history_error", {
    expect_error(cch_history(5), "class character")
    expect_error(cch_history("2030-05-22"), "`date` not found")
  })
})

# FIXME: the on.exit() delete the file cleans up the cached file
#   in the test - so on subsequent runs this test cant find the file
#   Not sure how to handle this?
# test_that("cch_history", {
#   vcr::use_cassette("cch_history", {
#     aa <- cch_history("2020-02-22")
#   })
#   expect_is(aa, "data.frame")
#   for (i in names(aa)) expect_is(aa[[i]], "character")
#   expect_gt(NROW(aa), 12000L)
#   expect_is(aa$summary[1], "character")
#   expect_is(jsonlite::fromJSON(aa$summary[1]), "list")
# })
