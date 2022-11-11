#' @title Name all chunks
#'
#' @description
#' Names all chunks of all Rmd files using the pattern `[file-name]-[number]`.
#'
#' @param collection (`character(1)`)\cr
#'   Collection to be named. Default `gallery`, names all chunks of gallery posts.
#' @param file (`character(1)`)\cr
#'   Single file to be named.
#'
#' @export
name_chunks_mlr3website = function(collection = "gallery", file = NULL) {
  rmds = if (is.null(file)) {
    root = rprojroot::find_package_root_file()
    path = file.path(root, "mlr-org", collection)
    rmds = list.files(path, pattern = "index.qmd$", full.names = TRUE, recursive = TRUE)
  } else {
    file
  }
  pattern = "^([[:space:]]*```\\{[rR])([[:alnum:] -]*)(.*\\})[[:space:]]*$"

  for (rmd in rmds) {
    message(sprintf("Renaming chunks in '%s'", basename(rmd)))

    lines = readLines(rmd)
    ii = which(stringi::stri_detect_regex(lines, "^[[:space:]]*```\\{[rR].*\\}$"))
    labels = sprintf("%s-%03i", basename(dirname(rmd)), seq_along(ii))
    lines[ii] = stringi::stri_replace_first_regex(lines[ii], pattern, sprintf("$1 %s$3", labels))
    writeLines(stringi::stri_trim_right(lines), con = rmd)
  }

  invisible(TRUE)
}
