all: install serve

.PHONY : help
help :
	@echo "install				: Install renv and restore virtual environment."
	@echo "restore				: Restore virtual environment to state in lock file."
	@echo "packageinstall		: Install mlr3website package without dependencies to virtual environment."
	@echo "serve				: Start a http server to serve the book."
	@echo "serverefresh			: Clear cache and start a http server to serve the book."
	@echo "render				: Render website."

install:
	Rscript -e 'install.packages("renv")' \
			-e 'renv::activate("mlr-org/")' \
			-e 'renv::restore("mlr-org/", prompt = FALSE)'

restore:
	Rscript -e 'renv::restore("mlr-org/", prompt = FALSE)'

packageinstall:
	Rscript -e 'renv::install(".", project = "mlr-org/")'

serve:
	Rscript -e 'renv::restore("mlr-org/", prompt = FALSE)'
	quarto preview mlr-org/

serverefresh:
	Rscript -e 'renv::restore("mlr-org/", prompt = FALSE)'
	quarto preview mlr-org/ --cache-refresh

clean:
	$(RM) -r mlr-org/_book mlr-org/.quarto mlr-org/site_libs;\
	find . -name "*.ps" -type f -delete;
	find . -name "*.dvi" -type f -delete;
	find . -type d -name "*_files" -exec rm -rf {} \;
	find . -type d -name "*_cache" -exec rm -rf {} \;

render:
	Rscript -e 'renv::restore("mlr-org/", prompt = FALSE)'
	quarto render mlr-org/
