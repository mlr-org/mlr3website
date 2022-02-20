#' @export
create_gallery_workflow = function(post_directory, post_file) {
  brew(file = system.file("template_render_gallery.yml", package = "mlr3website"),
    output = file.path(".github", "workflows", paste0("render-gallery-", post_file, ".yml")))
}
