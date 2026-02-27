all: serve

.PHONY : help
help :
	@echo "install				: Install the mlr3website package and dependencies."
	@echo "serve				: Start a http server to serve the book."
	@echo "serverefresh			: Clear cache and start a http server to serve the book."
	@echo "render				: Render website."
	@echo "clean-gallery-artifacts		: Remove render artifacts (index.html, index_files/, index.knit.md, index.rmarkdown) from gallery source directories."

install:
	Rscript -e 'pak::repo_add("https://mlr-org.r-universe.dev"); pak::pkg_install(c("mlr-org/survdistr", "."), dependencies = TRUE)'

install-nodeps:
	Rscript -e 'pak::repo_add("https://mlr-org.r-universe.dev"); pak::pkg_install(c("mlr-org/survdistr", "."))'

serve:
	quarto preview mlr-org/

serverefresh:
	quarto preview mlr-org/ --cache-refresh

clean:
	$(RM) -r mlr-org/_book mlr-org/.quarto mlr-org/site_libs;\
	find . -name "*.ps" -type f -delete;
	find . -name "*.dvi" -type f -delete;
	find . -type d -name "*_files" -exec rm -rf {} \;
	find . -type d -name "*_cache" -exec rm -rf {} \;

clean-gallery-artifacts:
	find mlr-org/gallery -name "index.html" -delete
	find mlr-org/gallery -name "index.knit.md" -delete
	find mlr-org/gallery -name "index.rmarkdown" -delete
	find mlr-org/gallery -type d -name "index_files" -exec rm -rf {} +

render:
	quarto render mlr-org/
