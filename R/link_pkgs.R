#' @title Convert a List Column of Packages to Character Columns with Links
#'
#' @description
#' Currently only supports linking to CRAN packages.
#'
#' @param x (`list()`)\cr
#'   List column.
#'
#' @export
link_pkgs = function(x, remove = character()) {
  checkmate::assert_list(x, "character")
  cran_pkgs = intersect(rownames(available.packages()), unlist(x, use.names = FALSE))

  mlr3misc::map_chr(x, function(pkgs) {
    pkgs = setdiff(pkgs, remove)
    ii = pkgs %in% cran_pkgs
    pkgs[ii] = mlr3misc::map_chr(pkgs[ii], function(x) as.character(htmltools::a(href = sprintf("https://cran.r-project.org/package=%s", x), x)))

    paste0(pkgs, collapse = ", ")
  })
}
