# mlr-org Website

[![build-website](https://github.com/mlr-org/mlr3website/actions/workflows/build-website.yml/badge.svg)](https://github.com/mlr-org/mlr3website/actions/workflows/build-website.yml)

# Project structure

* `mlr3website` - The root directory contains the `mlr3website` R package.
* `mlr-org/` - Quarto project.
* `mlr-org/posts/` - Blog posts.
* `mlr-org/gallery` - Gallery posts.
* `.github/workflows` contains workflows to build website and render gallery posts

## How to change the website

* The website consists of pages, blog and gallery posts.
* Pages are `.Qmd` files located in the `mlr-org/` directory (e.g. `packages.Rmd`).
* Blog posts are stored in `mlr-org/posts` and `blog.Rmd` automatically list them.
* Gallery posts are stored in `mlr-org/gallery` and `gallery.Rmd` automatically list them.
* Change the style only in `mlr-org/custom.scss` and add comments to all changes.
* See [quarto.org](https://quarto.org) to learn more about Quarto.

## Workflows

**build-website.yml**

Builds website.
Website is pushed to `gh-pages` branch.
Blog and gallery posts are freezed.
New posts are rendered.
