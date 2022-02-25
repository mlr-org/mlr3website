#' @title Convert Tabular Object to HTML Table
#'
#' @description
#' Converts a tabular R object with `knitr::kable()` to a html table. Wide
#' tables can be scrolled horizontally. The table is scrolled vertically if its
#' length exceeds 700px. The table header stays fixed at the top when scrolling
#' down. The following CSS rules must be applied.
#'
#' ```css
#' /* Scroll container around table*/
#' .table-responsive {
#'   width: 100%;
#'   max-height: 700px;
#'   overflow: auto;
#' }
#'
#' /* Table is stretched to full width */
#' .table {
#'   width: 100%;
#' }
#'
#' /* Sticky table header and background color */
#' .table > thead {
#'   color: white;
#'   background-color: #495148;
#'   inset-block-start: 0;
#'   position: sticky;
#' }
#'
#' /* Display line breaks */
#' .table td {
#'   white-space: pre-line;
#' }
#' ```
#'
#' @param tab (`any`)\cr
#'  Tabular R object.
#' @param ...
#'   Passed to `knitr::kable()`.
#'
#' @export
table_responsive = function(tab, ...) {
  div(class = "table-responsive",
    HTML(kable(tab, format = "html", table.attr = "class = 'table'", ...))
  )
}
