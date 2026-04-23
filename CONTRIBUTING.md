# Contributing to the mlr3 Website

Thank you for contributing to the mlr3website.
This document covers everything you need to know before editing the website.

# Project Structure

* `mlr3website` - The root directory contains the `mlr3website` R package.
* `mlr-org/` - Quarto project.
* `mlr-org/gallery` - Gallery posts.
* `.github/workflows` Contains workflows to build the website and render gallery posts

## Rendering the website

1. Clone this repository and navigate to the `mlr3website` directory.
2. Pull the Docker image: `docker pull mlrorg/mlr3-website`.
3. Preview the website:

Clone the repository, install the `mlr3website` R package, and preview using:

```bash
docker run --name mlr3website \
 -v $(pwd):/mlr3website_latest \
 --user $(id -u):$(id -g) \
 -e HOME=/tmp \
 --tmpfs /tmp:exec \
 --rm \
 -p 8888:8888 \
 mlrorg/mlr3-website quarto preview mlr3website_latest/mlr-org --port 8888 --host 0.0.0.0 --no-browser
```

`--user $(id -u):$(id -g)` ensures files written by the container (e.g. under `_freeze/`) are owned by your host user instead of root.
`--tmpfs /tmp:exec` and `-e HOME=/tmp` give the non-root user a writable tmpdir and home directory, which quarto, pandoc, and R caches require.

Access the preview at `http://0.0.0.0:8888`.
Add `--cache-refresh` to force a cache refresh.

## Adding a gallery post

The gallery is divided into five categories: `basic`, `optimization`, `pipelines`, `technical`, and `appliedml`.
Posts are stored in `mlr-org/gallery/{category}/{post-name}/index.qmd`.

1. Create a subdirectory in `mlr-org/gallery/{category}/` with a name following the pattern `YYYY-MM-DD-short-description`.
2. Create an `index.qmd` file in the subdirectory.
3. Include the setup file at the top of the post body: `{{< include ../../_setup.qmd >}}`.
4. Render the post using the `mlrorg/mlr3-website` Docker image before opening a PR:

```bash
docker run --name mlr3website \
  -v $(pwd):/workspace \
  -w /workspace \
  --user $(id -u):$(id -g) \
  -e HOME=/tmp \
  --tmpfs /tmp:exec \
  --rm \
  mlrorg/mlr3-website:latest \
  bash -c "cd mlr-org && quarto render gallery/{category}/{post}/index.qmd"
```

Because gallery posts are not re-rendered in CI, you must include the rendered output in the `mlr-org/_freeze/` subdirectory when submitting a pull request.

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

## Workflows

**build-website.yml**

Builds website.
On `main`, the website is pushed to `gh-pages` branch.
On pull request, the website is previewed with Netlify.
The gallery is frozen.

**gallery-weekly.yml**

The gallery is rendered in a Docker container (`mlrorg/mlr3-website`) which includes all required packages.
Runs once a week.

