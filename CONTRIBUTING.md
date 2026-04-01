# Contributing to the mlr3 Website


## Rendering the Website

Clone the repository, install the `mlr3website` R package, and preview using:

```bash
R CMD INSTALL .
quarto preview mlr-org/
```

The website is served at `http://localhost:4200` by default.

## Adding a Gallery Post

The gallery is divided into five categories: `basic`, `optimization`, `pipelines`, `technical`, and `appliedml`.
Posts are stored in `mlr-org/gallery/{category}/{post-name}/index.qmd`.

1. Create a subdirectory in `mlr-org/gallery/{category}/` with a name following the pattern `YYYY-MM-DD-short-description`.
2. Create an `index.qmd` file in the subdirectory.
3. Include the setup file at the top of the post body: `{{< include ../../_setup.qmd >}}`.
4. Render the post using the `mlrorg/mlr3-gallery` Docker image before opening a PR:

```bash
docker run --name mlr3-gallery \
  -v $(pwd):/workspace \
  -w /workspace \
  --rm \
  mlrorg/mlr3-gallery:latest \
  bash -c "cd mlr-org && quarto render gallery/{category}/{post}/index.qmd"
```

Because gallery posts are not re-rendered in CI, you must include the rendered output in the `mlr-org/_freeze/` subdirectory when submitting a pull request.
Rendering the website after adding a new gallery post with docker can fail with permission errors.
Run `sudo chown -R $USER .` to fix this.

### Rendering the gallery with docker

```bash
 docker run --name mlr3-gallery \
  -v $(pwd):/workspace \
  -w /workspace \
  --rm \
  mlrorg/mlr3-gallery:latest \
  bash -c "cd mlr-org && quarto render gallery/"
```

### Front Matter

Every gallery post must include a YAML front matter block. Use the following template:

```yaml
---
title: My Post Title
categories:
  - classification
  - tuning
author:
  - name: Your Name
date: MM-DD-YYYY
description: |
  One sentence starting with a verb. Do not repeat the title.
---
```

Required fields: `title`, `categories`, `author`, `date`, `description`.

### Description

- Use only one sentence.
- Start with a verb (e.g. "Learn how to…", "Demonstrate…", "Show…").
- Do not repeat the title.

## Style Guidelines

**R Code:**

- Use `=` for assignment, not `<-`.
- Name all code chunks following the pattern `{category-name}-{post-name}-{number}` (e.g. `{r basics-german-credit-001}`).
- Load packages at the top with `library()`.
- Include `{{< include ../../_setup.qmd >}}` at the start of each post; never call `set.seed()` outside of this setup file.
- Explain all code chunks in prose.

**English:**

- Avoid contractions (use "do not" instead of "don't").
- Refer to packages using backtick formatting: `` `mlr3` ``.
- Refer to functions as `` `function()` `` or `` `package::function()` ``.

**Quarto Formatting:**

- Include alt text for all figures.

## Changing Website Pages

Non-gallery pages are `.qmd` files located directly in `mlr-org/` (e.g. `mlr-org/faq.qmd`).
Edit these files and preview the changes with `quarto preview mlr-org/`.

## CSS

Global CSS rules live in `mlr-org/custom.scss`.
Follow the [BEM](https://getbem.com/) naming pattern and use SASS.
The website uses the Bootswatch [Yeti](https://bootswatch.com/yeti/) theme.

## Pull Requests

Before submitting a pull request:

- Render any new or modified gallery posts and include the updated `_freeze/` output.
- Check that the preview builds without errors.

For questions, open an issue or reach out on [Mattermost](https://lmmisld-lmu-stats-slds.srv.mwn.de/mlr_invite/).

## Installing the mlr3website R package

```R
pak::repo_add("https://mlr-org.r-universe.dev")
pak::pkg_install(c("mlr-org/survdistr", "."), dependencies = TRUE)
```
