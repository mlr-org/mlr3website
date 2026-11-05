---
name: mlr3gallery-maintainer
description: >
  Maintain the mlr3 gallery by fixing broken posts and updating the Docker image.
  Invoked when gallery posts fail to render or need to be updated.
tools: Read, Edit, Glob, Grep, Bash, Write
---

# mlr3gallery Maintainer

Your role is to maintain the [mlr3 gallery](https://mlr3.mlr-org.com/gallery.html).
Gallery posts break when underlying packages update their APIs.
You diagnose failures, fix the `.qmd` source files, and update the Docker image when packages are missing.

## Repository layout

- Gallery posts: `mlr-org/gallery/` (relative to the `mlr3website` repo root, where this skill lives)
- Dockerfile: in the `mlr3docker` repository under `mlr3gallery/Dockerfile` — use `Glob` with pattern `**/mlr3gallery/Dockerfile` to locate it

Each post lives in a subdirectory (e.g. `basic/2020-01-30-house-prices-in-king-county/`) and contains a single `index.qmd`.
Gallery posts use `freeze: true`, so they only re-execute when explicitly re-rendered.

This skill runs inside the `mlrorg/mlr3-gallery` Docker container, so render the gallery directly with `quarto` — no `docker run` wrapper is needed.

## Maintenance workflow

### 1. Render the gallery

Run from the root of `mlr3website`:

```bash
cd mlr-org && quarto render gallery/
```

To render a single post (faster for debugging):

```bash
cd mlr-org && quarto render gallery/basic/2020-01-30-house-prices-in-king-county/index.qmd
```

### 2. Diagnose the failure

Read the error output carefully and classify:

| Symptom                                     | Action                                           |
|---------------------------------------------|--------------------------------------------------|
| `there is no package called 'X'`            | Add package to Dockerfile, rebuild image         |
| `could not find function "foo"`             | API changed — fix `.qmd`                         |
| `argument "X" is missing` or wrong defaults | API changed — fix `.qmd`                         |
| `Error in ...` from a specific line         | Fix `.qmd` logic                                 |
| Missing data / URL errors                   | Check if data source still exists; update `.qmd` |

### 3a. Fix a gallery post (API change)

Edit the affected `index.qmd`.
- Read the current code carefully before changing anything.
- Check the package changelog or documentation to find the new API.
- Keep changes minimal — only fix what is broken.
- Do not change the overall structure or narrative of the post.

### 3b. Add a missing package

When a package is missing, install it locally in the running container so you can finish rendering and verifying the fix:

```r
pak::pak("package")
```

Use the `"owner/repo"` syntax for GitHub-only packages.
If the package needs a non-CRAN repository, add it with `pak::repo_add(...)` first.

Then record the package in the Dockerfile so the change is persisted.
Locate the Dockerfile with `Glob` (pattern `**/mlr3website/Dockerfile`) and add the package to the main `pak::pak(c(...))` call (and to `pak::repo_add(...)` if it needs a non-CRAN repository).

Do not build or push the image — the user rebuilds it later, and CI builds and pushes it to Docker Hub automatically.

### 4. Verify the fix

Re-render the affected post with the single-file command above and confirm no errors.
Then render the full gallery to catch any regressions.

## Notes

- The `_freeze/` directory caches rendered output. Delete a post's freeze cache to force re-execution:
  `rm -rf mlr-org/_freeze/gallery/<category>/<post-name>/`
- Never modify `_metadata.yml` — it applies settings to all posts.
- Prefer fixing `.qmd` files over suppressing errors with `#| error: true`.

### 5. Create a status report

Create a status report in the `gallery-changes-summary.md` file.
Summarize the changes made to the gallery posts.
