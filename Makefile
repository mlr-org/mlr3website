all: serve

.PHONY : help
help :
	@echo "clean				: Remove all build artifacts."
	@echo "clean-gallery-artifacts		: Remove render artifacts (index.html, index_files/, index.knit.md, index.rmarkdown) from gallery source directories."

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
