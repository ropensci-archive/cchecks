library("vcr")
vcr::vcr_configure(
  dir = "../fixtures",
  filter_sensitive_data = list("<<cchecks_api_token>>" =
    email_get_token("sckott7@gmail.com"))
)
vcr::check_cassette_names()
