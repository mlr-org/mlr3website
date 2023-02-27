#' @importFrom mlr3book ref_pkg
#' @export
mlr3book::ref_pkg

#' @title Hyperlink to Function Reference
#'
#' @description
#' Creates a markdown link to a function reference.
#'
#' @param topic Name of the topic to link against.
#' @param text Text to use for the link. Defaults to the topic name.
#' @param format Either markdown or HTML.
#'
#' @return (`character(1)`) markdown link.
#' @export
ref = function(topic, text = NULL, format = "markdown") {
  strip_parenthesis = function(x) sub("\\(\\)$", "", x)

  checkmate::assert_string(topic, pattern = "^[[:alnum:]._-]+(::[[:alnum:]._-]+)?(\\(\\))?$")
  checkmate::assert_string(text, min.chars = 1L, null.ok = TRUE)
  checkmate::assert_choice(format, c("markdown", "html"))

  topic = trimws(topic)
  text = if (is.null(text)) {
    topic
  } else {
    trimws(text)
  }

  if (stringi::stri_detect_fixed(topic, "::")) {
    parts = strsplit(topic, "::", fixed = TRUE)[[1L]]
    topic = parts[2L]
    name = strip_parenthesis(parts[2L])
    pkg = parts[1L]
  } else {
    update_db()
    matched = db$base[db$aliases[list(strip_parenthesis(topic)), c("Alias", "ID"), on = "Alias", nomatch = 0L], on = "ID", nomatch = NULL]

    # remove mlr3verse matches - these are just reexports with no helpful information on the man page
    matched = matched[get("Package") != "mlr3verse"]

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
    "html" = sprintf("<a href=\"%s\">%s</a>", url, text)
  )
}
