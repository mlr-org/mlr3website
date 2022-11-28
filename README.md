
# mlr-org Website <img src="man/figures/logo.png" align="right" width = "120" />

[![build-website](https://github.com/mlr-org/mlr3website/actions/workflows/build-website.yml/badge.svg)](https://github.com/mlr-org/mlr3website/actions/workflows/build-website.yml)

# Project Structure

  - `mlr3website` - The root directory contains the `mlr3website` R
    package.
  - `mlr-org/` - Quarto project.
  - `mlr-org/posts` - Blog posts.
  - `mlr-org/gallery` - Gallery posts.
  - `.github/workflows` Contains workflows to build the website and
    render gallery posts

## Setup

Before you can edit the website, you need to install a virtual
environment with renv. This ensures that we all edit the website with
the same package versions. The website is rendered in the CI in the same
virtual environment.

1.  Clone the `mlr-org/mlr3website` repository.

2.  Start a new R session in the `mlr-org/` directory.

3.  Call `renv::activate()` and then `renv::restore()` to download and
    install all required packages.

4.  Run the following command from your terminal to preview the website:
    
    ``` bash
    quarto preview mlr-org/
    ```

## Notes

**Freeze**

The blog and gallery posts are frozen i.e. the documents are not
re-rendered during a global project render. Calling `quarto preview
mlr-org/` or `quarto render mlr-org/` will not render the blog and
gallery posts again. Calling `quarto render` on a single file or
subdirectory will re-render the single file or all files in the
subdirectory.

**RSS**

The rss feed of the gallery is published on
[R-bloggers](https://www.r-bloggers.com/).

**CSS**

The global css rules are stored in `mlr-og/custom.scss`. When editing
the file, try to stick to the BEM naming pattern and use SASS. We use
the Bootswatch [Yeti](https://bootswatch.com/yeti/) theme. A few style
options are specified in `mlr-org/_quarto.yml` in the `Theme` section.

## How to Add a Blog Post

Blog posts are stored in `mlr-org/posts`.

1.  Create a subdirectory in `mlr-org/posts`.
2.  Start with a new `index.qmd` file and write your post.
3.  Download a suitable cover photo on [Unsplash](https://unsplash.com)
    in medium resolution. Square or landscape format photos look best in
    the overview.
4.  Open a pull request on GitHub.
5.  Commit your post once with the option `freeze: false` in YAML
    header. This will render the post on the CI once.
6.  Remove the freeze option and ask for a review.

If your post needs a new package or package version:

1.  Install the package with `renv::install()` in the virtual
    environment.
2.  Call `renv::snapshot()` to record the package in `renv.lock`.
3.  Commit `renv.lock` with the new post.

## How to Add a Gallery Post

The gallery is divided into four broad categories `basic`,
`optimization`, `pipelines` and `technical`. The posts are stored in the
corresponding subdirectories in `mlr-org/gallery`. If you write a
series, add it to the `series` directory.

1.  Create a subdirectory in `mlr-org/gallery/{category}`.
2.  Start with a new `index.qmd` file and write your post.
3.  Commit your post once with the option `freeze: false` in YAML
    header. This will render the post on the CI once.
4.  Remove the freeze option and ask for a review.

If your post needs a new package or package version:

1.  Install the package with `renv::install()` in the virtual
    environment.
2.  Call `renv::snapshot()` to record the package in `renv.lock`.
3.  Commit `renv.lock` with the new post.

## How to Change the Website

Pages are `.qmd` files located in the `mlr-org/` directory
(e.g. `packages.Rmd`). See [quarto.org](https://quarto.org) to learn
more about Quarto.

## Workflows

**build-website.yml**

Builds website. On `main`, the website is pushed to `gh-pages` branch.
On pull request, the website is previewed with Netlify. Blog and gallery
posts are frozen.

**gallery-weekly.yml**

The workflow restores the renv virtual environment and updates all
packages. Then all gallery posts are re-rerendered. Runs once a week.
