all: install serve

.PHONY: help

help:
	@echo "install : Install, activate and restore renv."
	@echo "serve : Activate renv, restore it and then serve the book. "

install:
	Rscript --no-init-file -e 'install.packages("renv")' \
	        -e 'renv::activate("mlr-org")' \
            -e 'renv::restore("mlr-org", prompt = FALSE)'

serve:
	quarto preview mlr-org
