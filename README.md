cchecks
=======



[![Build Status](https://travis-ci.com/ropenscilabs/cchecks.svg?branch=master)](https://travis-ci.com/ropenscilabs/cchecks)
[![codecov.io](https://codecov.io/github/ropenscilabs/cchecks/coverage.svg?branch=master)](https://codecov.io/github/ropenscilabs/cchecks?branch=master)

R client for the cran checks API at <https://cranchecks.info>

[Cran checks API docs][docs]

there's no authentication needed

## Install

Development version


```r
devtools::install_github("ropenscilabs/cchecks")
```


```r
library("cchecks")
```

## heartbeat


```r
cch_heartbeat()
#> $routes
#> [1] "/docs (GET)"                "/heartbeat (GET)"          
#> [3] "/pkgs (GET)"                "/pkgs/:pkg_name: (GET)"    
#> [5] "/maintainers (GET)"         "/maintainers/:email: (GET)"
```

## packages

all


```r
cch_pkgs(limit = 1)
#> $found
#> [1] 12516
#> 
#> $count
#> [1] 1
#> 
#> $offset
#> NULL
#> 
#> $error
#> NULL
#> 
#> $data
#>   _id package                                                       url
#> 1  A3      A3 https://cran.rstudio.com/web/checks/check_results_A3.html
#>   summary.any summary.ok summary.note summary.warning summary.error
#> 1       FALSE         12            0               0             0
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               checks
#> 1 r-devel-linux-x86_64-debian-clang, r-devel-linux-x86_64-debian-gcc, r-devel-linux-x86_64-fedora-clang, r-devel-linux-x86_64-fedora-gcc, r-devel-windows-ix86+x86_64, r-patched-linux-x86_64, r-patched-solaris-x86, r-release-linux-x86_64, r-release-windows-ix86+x86_64, r-release-osx-x86_64, r-oldrel-windows-ix86+x86_64, r-oldrel-osx-x86_64, 1.0.0, 1.0.0, 1.0.0, 1.0.0, 1.0.0, 1.0.0, 1.0.0, 1.0.0, 1.0.0, 1.0.0, 1.0.0, 1.0.0, 1.31, 1.04, 0, 0, 3, 0.92, 0, 1.13, 3, 0, 5, 0, 20.67, 18.38, 0, 0, 34, 21.01, 0, 21.7, 34, 0, 50, 0, 21.98, 19.42, 31.55, 27.85, 37, 21.93, 42.8, 22.83, 37, 0, 55, 0, OK, OK, OK, OK, OK, OK, OK, OK, OK, OK, OK, OK, https://www.R-project.org/nosvn/R.check/r-devel-linux-x86_64-debian-clang/A3-00check.html, https://www.R-project.org/nosvn/R.check/r-devel-linux-x86_64-debian-gcc/A3-00check.html, https://www.R-project.org/nosvn/R.check/r-devel-linux-x86_64-fedora-clang/A3-00check.html, https://www.R-project.org/nosvn/R.check/r-devel-linux-x86_64-fedora-gcc/A3-00check.html, https://www.R-project.org/nosvn/R.check/r-devel-windows-ix86+x86_64/A3-00check.html, https://www.R-project.org/nosvn/R.check/r-patched-linux-x86_64/A3-00check.html, https://www.R-project.org/nosvn/R.check/r-patched-solaris-x86/A3-00check.html, https://www.R-project.org/nosvn/R.check/r-release-linux-x86_64/A3-00check.html, https://www.R-project.org/nosvn/R.check/r-release-windows-ix86+x86_64/A3-00check.html, https://www.R-project.org/nosvn/R.check/r-release-osx-x86_64/A3-00check.html, https://www.R-project.org/nosvn/R.check/r-oldrel-windows-ix86+x86_64/A3-00check.html, https://www.R-project.org/nosvn/R.check/r-oldrel-osx-x86_64/A3-00check.html
#>              date_updated
#> 1 2018-05-10 19:30:47 UTC
```

by name


```r
x <- cch_pkgs(c("geojsonio", "leaflet", "MASS"))
lapply(x, "[[", c("data", "summary"))
#> [[1]]
#> [[1]]$any
#> [1] TRUE
#> 
#> [[1]]$ok
#> [1] 11
#> 
#> [[1]]$note
#> [1] 1
#> 
#> [[1]]$warning
#> [1] 0
#> 
#> [[1]]$error
#> [1] 0
#> 
#> 
#> [[2]]
#> [[2]]$any
#> [1] TRUE
#> 
#> [[2]]$ok
#> [1] 11
#> 
#> [[2]]$note
#> [1] 1
#> 
#> [[2]]$warning
#> [1] 0
#> 
#> [[2]]$error
#> [1] 0
#> 
#> 
#> [[3]]
#> [[3]]$any
#> [1] FALSE
#> 
#> [[3]]$ok
#> [1] 12
#> 
#> [[3]]$note
#> [1] 0
#> 
#> [[3]]$warning
#> [1] 0
#> 
#> [[3]]$error
#> [1] 0
```

## maintainers

all


```r
cch_maintainers(limit = 1)
#> $found
#> [1] 7388
#> 
#> $count
#> [1] 1
#> 
#> $offset
#> NULL
#> 
#> $error
#> NULL
#> 
#> $data
#>                      _id                  email           name
#> 1 00gerhard_at_gmail.com 00gerhard_at_gmail.com Daniel Gerhard
#>                                                                             url
#> 1 https://cran.rstudio.com/web/checks/check_results_00gerhard_at_gmail.com.html
#>                      table
#> 1 goric, mcprofile, 12, 12
#>                                                                                                                                                   packages
#> 1 goric, mcprofile, https://cran.rstudio.com/web/checks/check_results_goric.html, https://cran.rstudio.com/web/checks/check_results_mcprofile.html, NA, NA
#>              date_updated
#> 1 2018-05-10 19:25:58 UTC
```

by name


```r
cch_maintainers(c("123saga_at_gmail.com", "13268259225_at_163.com"))
#> [[1]]
#> [[1]]$error
#> NULL
#> 
#> [[1]]$data
#> [[1]]$data$`_id`
#> [1] "123saga_at_gmail.com"
#> 
#> [[1]]$data$email
#> [1] "123saga_at_gmail.com"
#> 
#> [[1]]$data$name
#> [1] "Sagar Ganapaneni"
#> 
#> [[1]]$data$url
#> [1] "https://cran.rstudio.com/web/checks/check_results_123saga_at_gmail.com.html"
#> 
#> [[1]]$data$table
#>       package note ok
#> 1 NOAAWeather    8  4
#> 
#> [[1]]$data$packages
#>       package
#> 1 NOAAWeather
#>                                                                  url
#> 1 https://cran.rstudio.com/web/checks/check_results_NOAAWeather.html
#>     check_result version
#> 1 NOTE, OK, 8, 4      NA
#> 
#> [[1]]$data$date_updated
#> [1] "2018-05-10 19:25:58 UTC"
#> 
#> 
#> 
#> [[2]]
#> [[2]]$error
#> NULL
#> 
#> [[2]]$data
#> [[2]]$data$`_id`
#> [1] "13268259225_at_163.com"
#> 
#> [[2]]$data$email
#> [1] "13268259225_at_163.com"
#> 
#> [[2]]$data$name
#> [1] "Xiao-Ping You"
#> 
#> [[2]]$data$url
#> [1] "https://cran.rstudio.com/web/checks/check_results_13268259225_at_163.com.html"
#> 
#> [[2]]$data$table
#>   package note
#> 1    XHWE   12
#> 
#> [[2]]$data$packages
#>   package                                                         url
#> 1    XHWE https://cran.rstudio.com/web/checks/check_results_XHWE.html
#>   check_result version
#> 1         NULL      NA
#> 
#> [[2]]$data$date_updated
#> [1] "2018-05-10 19:25:58 UTC"
```

## Meta

* Please [report any issues or bugs](https://github.com/ropenscilabs/cchecks/issues).
* License: MIT
* Get citation information for `cchecks` in R doing `citation(package = 'cchecks')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[docs]: https://cranchecks.info/docs
