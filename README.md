# mlr3 website

[![render-gallery](https://github.com/mlr-org/mlr3website/actions/workflows/render-gallery.yml/badge.svg?branch=main)](https://github.com/mlr-org/mlr3website/actions/workflows/render-gallery.yml)

The [mlr-org.com](https://mlr-org.com/) website is created with [Distill for R Markdown](https://rstudio.github.io/distill/website.html) and published with [GitHub Pages](https://docs.github.com/en/pages).

# Project Structure

* `mlr3website` - The root directory contains the `mlr3website` R package.
* `mlr-org/` - Distill project.
* `mlr-org/docs/` - Rendered website. Is created when `rmarkdown::render_site()` is called. Is not pushed to the remote repository.
* `mlr-org/_posts/` - Blog posts.
* `mlr-org/_gallery` - Gallery posts.
* `mlr-org/theme.css` - Custom styling.
* `.github` contains workflows to build website and render gallery posts

## How to change the website

* The website consists of pages, blog and gallery posts.
* Pages are `.Rmd` files located in the `mlr-org/` directory (e.g. `packages.Rmd`).
* Blog posts are stored in `mlr-org/_posts` and `blog.Rmd` automatically list them.
* Gallery posts are stored in `mlr-org/_gallery` and `gallery.Rmd` automatically list them.
* Change the style only in `mlr-org/theme.css` and add comments to all changes.
* The files in `mlr-org/docs/` are the standalone static website which is published with GitHub Pages.
Changes in `mlr-org/docs/` are overwritten by `rmarkdown::render_site()`.
* See [rstudio.github.io/distill](https://rstudio.github.io/distill/) to learn more about Distill.

## How to add a new blog post

Open the RStudio project in `mlr-org/` or set working directory to `mlr-org/`.

1. Add a new post with `distill::create_post("Title of Post in Title Case")`.
The new post is created within the `_posts/` subdirectory.
1. Write the post.
Place external images in the subdirectory.
1. Apply the [mlr-style](https://github.com/mlr-org/mlr3/wiki/Style-Guide#styler-mlr-style) to the post.
1. Name chunks with `name_chunks_mlr3website(collection = "posts")`.
1. Call `rmarkdown::render("_posts/2022-02-22-example-post/example-post.Rmd")` to render the post.
1. Run `rmarkdown::render_site(encoding = 'UTF-8')` to render the website.
The website is created within the `docs/` directory.
Open `index.html` to check your post.
1. Open a pull request and commit the subdirectory including all files.
Merged posts are published via GitHub Pages.

## How to add a new gallery post

Open the RStudio project in `mlr-org/` or set working directory to `mlr-org/`.

1. Add a new post with `distill::create_post("Title of Post in Title Case", collection = "gallery")`.
The new post is created within the `_gallery/` subdirectory.
1. Write the post.
Place external images in the subdirectory.
1. Name chunks with `name_chunks_mlr3website(collection = "gallery")`.
1. Call `rmarkdown::render("_gallery/2022-02-22-example-post/example-post.Rmd")` to render the post.
1. Run `rmarkdown::render_site(encoding = 'UTF-8')` to render the website.
The website is created within the `docs/` directory.
Open `index.html` to check your post.
1. Open a pull request and commit the subdirectory including all files.
Merged gallery posts are published via GitHub Pages.

## How to style tables

1. Limit tables to important columns and rows.

```r
as.data.table(bmr)[, .(learner_id, classif.ce)]

head(as.data.table(bmr))
```


1. Convert `data.table::data.table()` and `data.frame()` to html tables.


````r
```{r chunk-name, results = 'hide'}
as.data.table(bmr)
```

```{r chunk-name-2, echo = FALSE}
as.data.table(bmr) %>%
  kable(format = "html") %>%
  kable_styling(full_width = TRUE)
```
````

1. Apply a wider [distill layout](https://rstudio.github.io/distill/figures.html) for wide tables.


````r
```{r chunk-name, layout="l-body-outset"}
as.data.table(bmr)
```

```{r chunk-name-2, layout="l-page"}
as.data.table(bmr)
```
````

1. Use a vertical scroll box if the table is too long.

````r
```{r chunk-name, echo = FALSE}
as.data.table(bmr) %>%
  kable(format = "html") %>%
  kable_styling(full_width = TRUE) %>%
  scroll_box(height = "400px", extra_css = "border: 0px !important;")
```
````

## How to include figures

1. Increase the default size of figures.

````r
```{r chunk-name, fig.width=10, fig.height=10}
plot()
```
````

1. Apply a wider [distill layout](https://rstudio.github.io/distill/figures.html) for wide figures.


````r
```{r chunk-name, layout="l-body-outset"}
plot()
```

```{r chunk-name-2, layout="l-page"}
plot()
```
````

# Workflows

**build-website.yml**

Builds website.
Website is pushed to `gh-pages` branch.
Does not render blog or gallery posts again.

**render-gallery.yml**

Only runs when a gallery post is added or changed.
Renders all gallery post and builds website.
Website is pushed to `gh-pages` branch.
