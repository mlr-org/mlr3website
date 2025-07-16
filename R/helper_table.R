#' @export
list_cell = function(value) {
  if (!length(value)) return(NULL)
  tags$ul(class = "object-table__list",
    map(value, function(x) tags$li(class = "object-table__list-item", x))
  )
}

#' @export
package_list_cell = function(value) {
  if (!length(value)) return(NULL)
  tags$ul(class = "object-table__list",
    map(value, function(x) if(is.na(x)) browser(); tags$li(class = "object-table__list-item", ref_pkg(x, pkg = x, format = "htmltools")))
  )
}

#' @export
package_cell = function(value) {
  if (!length(value)) return(NULL)
  mlr3website::ref_pkg(value, pkg = value, format = "htmltools")
}
