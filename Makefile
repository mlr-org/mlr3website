IMAGE = mlrorg/mlr3-website:latest
PORT = 8888
# the image is only built for amd64, arm64 hosts have to emulate it
PLATFORM = linux/amd64

# run as the host user so that files written to _freeze/ are not owned by root
DOCKER_RUN = docker run --rm \
	--platform $(PLATFORM) \
	-v $(CURDIR):/workspace \
	-w /workspace/mlr-org \
	--user $$(id -u):$$(id -g) \
	-e HOME=/tmp \
	--tmpfs /tmp:exec

.DEFAULT_GOAL := help

.PHONY: help pull preview render render-post clean clean-gallery-artifacts

help:
	@echo "pull                     : Pull the Docker image used to render the website."
	@echo "preview                  : Preview the website at http://localhost:$(PORT)."
	@echo "render                   : Render the full website to mlr-org/_site."
	@echo "render-post POST=<path>  : Render a gallery post, e.g. POST=gallery/basic/2020-03-11-basics-german-credit."
	@echo "clean                    : Remove all build artifacts."
	@echo "clean-gallery-artifacts  : Remove render artifacts (index.html, index_files/, index.knit.md, index.rmarkdown) from gallery source directories."

pull:
	docker pull --platform $(PLATFORM) $(IMAGE)

preview:
	$(DOCKER_RUN) -p $(PORT):$(PORT) $(IMAGE) quarto preview --port $(PORT) --host 0.0.0.0 --no-browser

render:
	$(DOCKER_RUN) $(IMAGE) quarto render

render-post:
	@test -n "$(POST)" || { echo "Usage: make render-post POST=gallery/{category}/{post}"; exit 1; }
	$(DOCKER_RUN) $(IMAGE) quarto render $(POST)/index.qmd

# _freeze/ is committed and must survive
clean:
	$(RM) -r mlr-org/_site mlr-org/.quarto mlr-org/site_libs
	find mlr-org -path mlr-org/_freeze -prune -o -type d \( -name "*_files" -o -name "*_cache" \) -prune -exec rm -rf {} +

clean-gallery-artifacts:
	find mlr-org/gallery -name "index.html" -delete
	find mlr-org/gallery -name "index.knit.md" -delete
	find mlr-org/gallery -name "index.rmarkdown" -delete
	find mlr-org/gallery -type d -name "index_files" -exec rm -rf {} +
