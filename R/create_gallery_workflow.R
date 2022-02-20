#' @export
create_gallery_workflow = function(post_directory, post_file) {
  brew(file = file.path("inst", "template_render_gallery.yml"),
    output = file.path(".github", "workflows", paste0("render-gallery-", file_path_sans_ext(post_file), ".yml")))
}
