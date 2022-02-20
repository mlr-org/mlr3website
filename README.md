# Project Structure

* `mlr3website` R package is located in the root directory
* `mlr-org/` contains distill website
* `.github` contains workflows to build website and render gallery posts

# Workflows

**build-website**

Builds website.
Website is pushed to `gh-pages` branch.
Does not render blog or gallery posts again.

**render-gallery.yml**

Only runs when a gallery post is added or changed.
Renders all gallery post and builds website.
Website is pushed to `gh-pages` branch.
