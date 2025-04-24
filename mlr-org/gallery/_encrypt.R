#!/usr/bin/env Rscript

#sink("debug.log", split = TRUE)

#out_files = strsplit(Sys.getenv("QUARTO_PROJECT_OUTPUT_FILES", ""), "\n", fixed = TRUE)[[1]]
#html_files = out_files[grepl("appliedml.*\\.html?$", out_files, ignore.case = TRUE)]

html_files = list.files(pattern = "index.html", recursive = TRUE)
html_files = html_files[grepl("appliedml/.*-sol/", html_files)]

for (html in html_files) {
  src = sub("_site/|_site\\\\|_site", "", html)
  src = sub("\\.html?$", ".qmd", src)
  src = normalizePath(paste0(getwd(), "/", src))
  if (!file.exists(src)) next
  
  # Read only the YAML header
  front = tryCatch(rmarkdown::yaml_front_matter(src), error = function(e) NULL)
  protect = front$params$showsolution
  if (is.null(front) || !isTRUE(protect)) next
  
  abr = abbreviate(front$title, minlength = 8)
  
  staticryptR::staticryptr(
    files     = html,
    directory = ".",
    password  = abr,
    short     = TRUE
  )
  
  message("encrypted ", html)
}
#sink()
