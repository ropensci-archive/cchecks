cchecks
=======



[![Build Status](https://travis-ci.com/ropenscilabs/cchecks.svg?branch=master)](https://travis-ci.com/ropenscilabs/cchecks)
[![codecov.io](https://codecov.io/github/ropenscilabs/cchecks/coverage.svg?branch=master)](https://codecov.io/github/ropenscilabs/cchecks?branch=master)

R client for the CRAN checks API at <https://cranchecks.info>

[CRAN checks API docs][docs]

authentication is only needed for the CRAN checks API for the functions that start with `cchn`

See https://docs.ropensci.org/cchecks for full documentation on `cchecks`

## Install


```r
remotes::install_github("ropenscilabs/cchecks")
```


```r
library("cchecks")
```

## heartbeat

- `cch_heartbeat()`

## packages

- current day package check data: `cch_pkgs()` or `cch_pkgs("packagename")`
- historical package check data (30 days back): `cch_pkgs_history()`
- search historical data: `cch_pkgs_search()`

## maintainers

- all maintainers: `cch_maintainers()`
- maintainers by email: `cch_maintainers("maelle.salmon_at_yahoo.se")`

## notifications

Functions for working with notifications are all prefixed with `cchn`. 

`cchn` functions are designed to be used from within an R package directory. The functions
look for the package name and maintainer email address. Functions copy heavily from 
https://github.com/r-hub/rhub

The functions

- `cchn_register()`: registration
- `cchn_pkg_rule_list()`/`cchn_rule_list()`: list your own rules
- `cchn_pkg_rule_get()`/`cchn_rule_get()`: get a rule by id
- `cchn_pkg_rule_add()`/`cchn_rule_add()`: create a rule
- `cchn_pkg_rule_delete()`/`cchn_rule_delete()`: delete a rule by id (get id from `cchn_pkg_rule_list`/`cchn_rule_list`)

Functions prefixed with `cchn_pkg_` operate within a package 
directory. That is, your current working directory is an R
package, and is the package for which you want to handle CRAN checks 
notifications. These functions make sure that you are inside of 
an R package, and use the email address and package name based
on the directory you're in.

Functions prefixed with just `cchn_` do not operate within a package.
These functions do not guess package name at all, but require the user
to supply a package name (for those functions that require a package name);
and instead of guessing an email address from your package, we guess email
from the cached cchecks email file (see `?cchn_register`).

The first thing to do is to register an email address. In an R session in a working directory for 
one of your packages that is on CRAN, run `cchn_register()`. This function:

- registers your email address
- a validation email is sent to you right away with your token
- paste the token from the amil into the R session
- the email and token are then saved in a file on your machine
- all `cchn_rule*` functions use this cached token
- you don't need to pass the token in any `cchn` function calls

If you run `cchn_register()` in the same package directory (with the same email address), 
you'll be issued a new token, which will be updated in your cached token file.

It's entirely possible to have more than one email address you use across different R packages. 
If you run `cchn_register()` in a different package directory (with a different email address
from a previous run of `cchn_register()`), you'll be issued a different token associated 
with that new email address.

See `?cchn_rules` for details on how the rules work and many examples of adding rules.

Note that you can only manage your own rules. You can not list, get, or delete rules 
of other users.

## Meta

* Please [report any issues or bugs](https://github.com/ropenscilabs/cchecks/issues).
* License: MIT
* Get citation information for `cchecks` in R doing `citation(package = 'cchecks')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[docs]: https://cranchecks.info/docs
[coc]: https://github.com/ropenscilabs/cchecks/blob/master/CODE_OF_CONDUCT.md
