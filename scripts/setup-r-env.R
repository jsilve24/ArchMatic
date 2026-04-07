#!/usr/bin/env Rscript

options(repos = c(CRAN = "https://cloud.r-project.org"))

cran_packages <- c(
  "tidyverse",
  "languageserver",
  "mgcv",
  "lme4",
  "fido",
  "BH",
  "breakerofchains",
  "Rcpp",
  "RcppEigen",
  "RcppNumerical",
  "rstan",
  "ALDEx3"

)

bioc_packages <- c(
  "philr"
)

github_packages <- c(
  "stan-dev/cmdstanr"
)

github_package_name <- function(repo) {
  sub(".*/", "", repo)
}

safe_require_namespace <- function(pkg) {
  suppressWarnings(requireNamespace(pkg, quietly = TRUE))
}

ensure_helper <- function(pkg, installer) {
  if (safe_require_namespace(pkg)) {
    return(TRUE)
  }

  message(sprintf("Installing helper package '%s'...", pkg))

  ok <- tryCatch({
    installer()
    safe_require_namespace(pkg)
  }, error = function(err) {
    message(sprintf("Failed to install helper package '%s': %s", pkg, conditionMessage(err)))
    FALSE
  })

  isTRUE(ok)
}

ensure_biocmanager <- function() {
  ensure_helper("BiocManager", function() {
    install.packages("BiocManager", quiet = TRUE)
  })
}

ensure_remotes <- function() {
  ensure_helper("remotes", function() {
    install.packages("remotes", quiet = TRUE)
  })
}

installed_version_or_null <- function(pkg) {
  if (!safe_require_namespace(pkg)) {
    return(NULL)
  }

  as.character(utils::packageVersion(pkg))
}

available_cran_version_or_null <- function(pkg) {
  ap <- tryCatch(utils::available.packages(), error = function(err) NULL)
  if (is.null(ap) || !pkg %in% rownames(ap)) {
    return(NULL)
  }

  unname(ap[pkg, "Version"])
}

available_bioc_version_or_null <- function(pkg) {
  if (!ensure_biocmanager()) {
    return(NULL)
  }

  ap <- tryCatch(
    utils::available.packages(repos = BiocManager::repositories()),
    error = function(err) NULL
  )
  if (is.null(ap) || !pkg %in% rownames(ap)) {
    return(NULL)
  }

  unname(ap[pkg, "Version"])
}

needs_update <- function(installed, available) {
  if (is.null(installed)) {
    return(TRUE)
  }

  if (is.null(available) || identical(available, "available")) {
    return(FALSE)
  }

  utils::compareVersion(installed, available) < 0
}

install_cran_package <- function(pkg) {
  installed <- installed_version_or_null(pkg)
  available <- available_cran_version_or_null(pkg)

  if (!is.null(installed) && !is.null(available) && !needs_update(installed, available)) {
    message(sprintf("Skipping CRAN package '%s' (%s is current).", pkg, installed))
    return(TRUE)
  }

  action <- if (is.null(installed)) "Installing" else sprintf("Updating from %s", installed)
  message(sprintf("%s CRAN package '%s'...", action, pkg))

  tryCatch({
    install.packages(pkg, quiet = TRUE)
    new_version <- installed_version_or_null(pkg)
    message(sprintf("Installed CRAN package '%s' (%s).", pkg, new_version %||% "unknown version"))
    TRUE
  }, error = function(err) {
    message(sprintf("Failed CRAN package '%s': %s", pkg, conditionMessage(err)))
    FALSE
  })
}

install_bioc_package <- function(pkg) {
  if (!ensure_biocmanager()) {
    message(sprintf("Skipping Bioconductor package '%s' because BiocManager is unavailable.", pkg))
    return(FALSE)
  }

  installed <- installed_version_or_null(pkg)
  available <- available_bioc_version_or_null(pkg)

  if (!is.null(installed) && !is.null(available) && !needs_update(installed, available)) {
    message(sprintf("Skipping Bioconductor package '%s' (%s is installed).", pkg, installed))
    return(TRUE)
  }

  action <- if (is.null(installed)) "Installing" else sprintf("Checking/updating from %s", installed)
  message(sprintf("%s Bioconductor package '%s'...", action, pkg))

  tryCatch({
    BiocManager::install(pkg, ask = FALSE, update = FALSE, quiet = TRUE)
    new_version <- installed_version_or_null(pkg)
    if (!is.null(new_version)) {
      message(sprintf("Installed Bioconductor package '%s' (%s).", pkg, new_version))
      TRUE
    } else {
      message(sprintf("Bioconductor package '%s' did not install cleanly.", pkg))
      FALSE
    }
  }, error = function(err) {
    message(sprintf("Failed Bioconductor package '%s': %s", pkg, conditionMessage(err)))
    FALSE
  })
}

install_github_package <- function(repo) {
  pkg <- github_package_name(repo)

  if (!ensure_remotes()) {
    message(sprintf("Skipping GitHub package '%s' because remotes is unavailable.", repo))
    return(FALSE)
  }

  installed <- installed_version_or_null(pkg)
  action <- if (is.null(installed)) "Installing" else sprintf("Refreshing from %s", installed)
  message(sprintf("%s GitHub package '%s'...", action, repo))

  tryCatch({
    # remotes compares the installed remote SHA to the current upstream SHA
    # and skips reinstalling when the package is already current.
    remotes::install_github(repo, upgrade = "never", dependencies = TRUE, quiet = TRUE)
    new_version <- installed_version_or_null(pkg)
    message(sprintf("Finished GitHub package '%s' (%s).", repo, new_version %||% "unknown version"))
    TRUE
  }, error = function(err) {
    message(sprintf("Failed GitHub package '%s': %s", repo, conditionMessage(err)))
    FALSE
  })
}

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0 || is.na(x)) y else x
}

run_installs <- function() {
  results <- c()

  for (pkg in cran_packages) {
    results[paste0("CRAN:", pkg)] <- install_cran_package(pkg)
  }

  for (pkg in bioc_packages) {
    results[paste0("BIOC:", pkg)] <- install_bioc_package(pkg)
  }

  for (repo in github_packages) {
    results[paste0("GITHUB:", repo)] <- install_github_package(repo)
  }

  failed <- names(results)[!results]

  message("")
  message("R environment setup summary:")
  message(sprintf("  Succeeded: %d", sum(results)))
  message(sprintf("  Failed:    %d", length(failed)))

  if (length(failed) > 0) {
    message("Failed items:")
    for (item in failed) {
      message(sprintf("  - %s", item))
    }
    quit(status = 1)
  }
}

run_installs()
