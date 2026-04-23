#' @export
list_cell = function(value) {
  if (!length(value)) return(NULL)
  htmltools::tags$ul(class = "object-table__list",
    lapply(value, function(x) htmltools::tags$li(class = "object-table__list-item", x))
  )
}

#' @export
package_list_cell = function(value) {
  if (!length(value)) return(NULL)
  htmltools::tags$ul(class = "object-table__list",
    lapply(value, function(x) htmltools::tags$li(class = "object-table__list-item", ref_pkg(x, pkg = x, format = "htmltools")))
  )
}

#' @export
package_cell = function(value) {
  if (!length(value)) return(NULL)
  mlr3website::ref_pkg(value, pkg = value, format = "htmltools")
}
