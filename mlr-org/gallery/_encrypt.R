#!/usr/bin/env Rscript

#sink("debug.log", split = TRUE)
required_packages = c("staticryptR", "rmarkdown")
to_install = setdiff(required_packages, rownames(installed.packages()))
if (length(to_install)) {
  install.packages(to_install, repos = "https://cloud.r-project.org")
}

if (!staticryptR:::is_staticrypt_available()) {
  message("staticrypt not found – downloading once …")
  staticryptR::install_staticrypt()
}

#library(jsonlite)   # to read the _freeze/… JSON records
#library(yaml)       # to read YAML front-matter

out_files = strsplit(Sys.getenv("QUARTO_PROJECT_OUTPUT_FILES", ""), "\n", fixed = TRUE)[[1]]
html_files = out_files[grepl("appliedml.*\\.html?$", out_files, ignore.case = TRUE)]
# set.seed(1)
# rand_pwd = function(n = 8) {
#   paste0(sample(c(letters, LETTERS, 0:9), n, replace = TRUE), collapse = "")
# }
# pwd = lapply(html_files, function(x) {
#   rand_pwd(8)
# })

for (html in html_files) {
  src = sub("_site", "", html)
  src = sub("\\.html?$", ".qmd", src)
  src = normalizePath(paste0(getwd(), src))
  if (!file.exists(src)) next
  
  # Read only the YAML header
  front = tryCatch(rmarkdown::yaml_front_matter(src), error = function(e) NULL)
  protect = front$params$showsolution
  if (is.null(front) || !isTRUE(protect)) next
  
  abr = abbreviate(front$title, minlength = 8)

  staticryptR::staticryptr(
    files     = html,
    directory = ".",        # overwrite in place
    password  = abr,
    short     = TRUE
  )
  
  message("encrypted ", html)
}
#sink()
