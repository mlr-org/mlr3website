update_db = function() {
  if (is.null(db$base) || is.null(db$aliases)) {
    hdb = hsearch_db(package = unique(c(db$index, db$hosted)), types = "help")
    db$base = setkeyv(as.data.table(hdb$Base), "ID")
    db$aliases = setkeyv(as.data.table(hdb$Aliases), "Alias")
  }
}

#' @title Hyperlink to Function Reference
#'
#' @description
#' Creates a markdown link to a function reference.
#'
#' @param topic Name of the topic to link against.
#' @param text Text to use for the link. Defaults to the topic name.
#' @param format Either markdown or HTML.
#'
#' @return `character(1)` | `shiny.tag`
#' @export
ref = function(topic, text = topic, format = "markdown") {
  strip_parenthesis = function(x) sub("\\(\\)$", "", x)

  checkmate::assert_string(topic, pattern = "^[[:alnum:]._-]+(::[[:alnum:]._-]+)?(\\(\\))?$")
  checkmate::assert_string(text, min.chars = 1L)
  checkmate::assert_choice(format, c("markdown", "html", "htmltools"))

  topic = trimws(topic)
  text = trimws(text)

  if (stringi::stri_detect_fixed(topic, "::")) {
    parts = strsplit(topic, "::", fixed = TRUE)[[1L]]
    topic = parts[2L]
    name = strip_parenthesis(parts[2L])
    pkg = parts[1L]
  } else {
    update_db()
    matched = db$base[db$aliases[list(strip_parenthesis(topic)), c("Alias", "ID"), on = "Alias", nomatch = 0L], on = "ID", nomatch = NULL]
    if (nrow(matched) == 0L) {
      stop(sprintf("Could not find help page for topic '%s'", topic))
    }
    if (nrow(matched) >= 2L) {
      lgr$warn("Ambiguous link to '%s': %s", topic, paste0(paste(matched$Package, matched$Name, sep = "::"), collapse = " | "))
      matched = head(matched, 1L)
    }

    pkg = matched$Package
    name = matched$Name
    lgr$debug("Resolved '%s' to '%s::%s'", topic, pkg, name)
  }

  if (pkg %in% db$hosted) {
    url = sprintf("https://%s.mlr-org.com/reference/%s.html", pkg, name)
  } else {
    url = sprintf("https://www.rdocumentation.org/packages/%s/topics/%s", pkg, name)
  }

  switch(format,
    "markdown" = sprintf("[`%s`](%s)", text, url),
    "html" = sprintf("<a href=\"%s\">%s</a>", url, text),
    "htmltools" = htmltools::a(href = url, text)
  )
}

#' @title Hyperlink to Package
#'
#' @description
#' Links either to respective mlr3 website or to CRAN page.
#'
#' @param pkg Name of the package.
#' @param runiverse If `TRUE` (default) then creates R-universe link instead of GH
#' @inheritParams ref
#'
#' @return (`character(1)`) markdown link.
#' @export
ref_pkg = function(pkg, runiverse = TRUE, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "(^[[:alnum:]._-]+$)|(^[[:alnum:]_-]+/[[:alnum:]._-]+$)")
  checkmate::assert_choice(format, c("markdown", "html", "htmltools"))
  pkg = trimws(pkg)

  if (grepl("/", pkg, fixed = TRUE)) {
    if (runiverse) {
      ru_pkg(pkg, format = format)
    } else {
      gh_pkg(pkg, format = format)
    }

  } else if (pkg %in% db$hosted) {
    mlr_pkg(pkg, format = format)
  } else {
    cran_pkg(pkg, format = format)
  }
}

cran_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]._-]+$")
  checkmate::assert_choice(format, c("markdown", "html", "htmltools"))
  pkg = trimws(pkg)

  if (pkg %in% c("stats", "graphics", "datasets")) {
    return(pkg)
  }
  url = sprintf("https://cran.r-project.org/package=%s", pkg)
  switch(format,
    "markdown" = sprintf("[%s](%s)", pkg, url),
    "html" = sprintf("<a href = \"%s\">%s</a>", url, pkg),
    "htmltools" = htmltools::a(href = url, pkg)
  )
}

mlr_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]._-]+$")
  checkmate::assert_choice(format, c("markdown", "html", "htmltools"))
  pkg = trimws(pkg)

  url = sprintf("https://%1$s.mlr-org.com", pkg)
  switch(format,
    "markdown" = sprintf("[%s](%s)", pkg, url),
    "html" = sprintf("<a href = \"%s\">%s</a>", url, pkg),
    "htmltools" = htmltools::a(href = url, pkg)
  )
}

gh_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]_-]+/[[:alnum:]._-]+$")
  checkmate::assert_choice(format, c("markdown", "html", "htmltools"))
  pkg = trimws(pkg)

  parts = strsplit(pkg, "/", fixed = TRUE)[[1L]]
  url = sprintf("https://github.com/%s", pkg)
  switch(format,
    "markdown" = sprintf("[%s](%s)", parts[2L], url),
    "html" = sprintf("<a href = \"%s\">%s</a>", url, parts[2L]),
    "htmltools" = htmltools::a(href = url, parts[2L])
  )
}

ru_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]_-]+/[[:alnum:]._-]+$")
  checkmate::assert_choice(format, c("markdown", "html", "htmltools"))

  parts = strsplit(pkg, "/", fixed = TRUE)[[1L]]
  url = sprintf("https://%s.r-universe.dev/ui#package:%s", parts[1L], parts[2L])
  switch(format,
    "markdown" = sprintf("[%s](%s)", parts[2L], url),
    "html" = sprintf("<a href = \"%s\">%s</a>", url, parts[2L]),
    "htmltools" = htmltools::a(href = url, parts[2L])
  )
}

#' @name paradox
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3misc
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3data
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3db
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3proba
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3pipelines
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3learners
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3filters
#' @title Helper mlr links
#' @export
NULL

#' @name bbotk
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3tuning
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3fselect
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3cluster
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3spatiotempcv
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3spatial
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3extralearners
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3tuningspaces
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3hyperband
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3mbo
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3viz
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3verse
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3benchmark
#' @title Helper mlr links
#' @export
NULL
