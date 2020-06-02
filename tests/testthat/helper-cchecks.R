# Sys.setenv(CCHECKS_TOKEN_SCKOTT7 = "stuff")
# Sys.setenv(CCHECKS_TOKEN_MYRMECOCYSTUS = "things")
path <- file.path(rappdirs::user_data_dir("cranchecks", "cchecks"),
  "emails.csv")
if (!file.exists(path)) {
  z <- data.frame(
    V1 = c("sckott7@gmail.com", "myrmecocystus@gmail.com"),
    V2 = c(Sys.getenv("CCHECKS_TOKEN_SCKOTT7"),
      Sys.getenv("CCHECKS_TOKEN_MYRMECOCYSTUS"))
  )
  utils::write.table(z, file = path, sep = ",", col.names = FALSE,
      row.names = FALSE)
}

library("vcr")
vcr::vcr_configure(
  dir = "../fixtures",
  filter_sensitive_data = list(
    "<<cchecks_api_token>>" = email_get_token("sckott7@gmail.com"),
    "<<cchecks_api_token2>>" = email_get_token("myrmecocystus@gmail.com")
  )
)
vcr::check_cassette_names()

# name = "foobar"
fake_pkg <- function(name) {
  stopifnot(is.character(name))
  path <- file.path(tempdir(), name)
  fields <- list(
   `Authors@R` = 'person("Jane", "Doe", email = "sckott7@gmail.com", role = c("aut", "cre"))'
  )
  usethis::create_package(path, fields = fields, open = FALSE)
  return(path)
}
