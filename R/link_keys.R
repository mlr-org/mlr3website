#' @title Insert Links into a Column of Keys
#'
#' @description
#' Uses `ref()` from mlr3book.
#'
#' @param x (`list()`)\cr
#'   Key.
#'
#' @export
link_keys = function(keys, prefix) {
  checkmate::assert_character(keys, any.missing = FALSE)
  checkmate::assert_string(prefix)

  mlr3misc::map_chr(keys, function(key) {
    mlr3book::ref(sprintf("%s_%s", prefix, key), text = key, format = "html")
  })
}

