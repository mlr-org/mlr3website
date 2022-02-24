#' @export
responsive_table = function(tab) {
  div(class = "table-responsive",
    HTML(kable(tab, format = "html", table.attr = "class = 'table'"))
  )
}
