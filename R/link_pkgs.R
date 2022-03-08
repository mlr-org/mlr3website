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

  mlr3misc::map_chr(x, function(pkgs) {
    if (checkmate::test_scalar_na(pkgs)) {
      return("")
    }
    pkgs = setdiff(pkgs, remove)
    paste0(mlr3misc::map_chr(pkgs, mlr3book::ref_pkg, format = "html"), collapse = ", ")
  })
}
