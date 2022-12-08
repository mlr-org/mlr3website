all: install serve

.PHONY: help

help:
	@echo "install : Install mlr3website, activate and restore the renv file."
	@echo "serve : Activate renv, restore it and then serve the book. "


install:
	Rscript -e 'install.packages("renv")' \
	        -e 'renv::activate("mlr-org")' \
            -e 'renv::restore("mlr-org", prompt = FALSE)'

serve:
	quarto preview mlr-org
