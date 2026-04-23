# mlr3website

## Website overview

The mlr3website is a Quarto-based website for the mlr3 R package ecosystem, hosted at https://mlr-org.com/.
It serves as the central hub for the project, featuring package overview pages, a gallery of tutorials, performance benchmarks, and community resources.

The repository also contains a small R helper layer (`R/`, `DESCRIPTION`) used by the website's `.qmd` files.
This is not a CRAN package — the helpers exist only to support rendering.

## Project structure

- `mlr-org/_quarto.yml` — website configuration, navigation, and theme.
- `mlr-org/index.qmd` — homepage.
- `mlr-org/gallery/` — gallery posts across five categories: `basic`, `optimization`, `pipelines`, `technical`, `appliedml`.
- `mlr-org/gallery/{category}/{YYYY-MM-DD-short-description}/index.qmd` — individual gallery posts.
- `mlr-org/_setup.qmd` — shared setup included at the top of every gallery post.
- `mlr-org/_freeze/` — pre-rendered gallery output (committed to the repo).
- `mlr-org/custom.scss` — custom SASS styling (BEM naming, Bootswatch Yeti theme).
- `mlr-org/publications.bib` — bibliography.
- `mlr-org/benchmarks/` — performance benchmark pages.
- `R/links.R` — helper functions: `ref()`, `ref_pkg()`.
- `R/helper_table.R` — HTML table utilities: `list_cell()`, `package_list_cell()`, `package_cell()`.
- `R/name_chunks.R` — chunk naming utility for gallery posts.
- `R/zzz.R` — package initialization and mlr3 ecosystem package database.

## Key commands

```
# Preview the website locally (auto-reloads on save)
quarto preview mlr-org

# Render the full website
quarto render mlr-org

# Render a single gallery post
quarto render mlr-org/gallery/{category}/{post}/index.qmd

# Load the helper functions in R/ for interactive use
Rscript -e "devtools::load_all(); code"

# Clean generated artifacts
make clean

# Clean gallery artifacts to force re-rendering
make clean-gallery-artifacts
```

## Gallery post structure rules

Every gallery post `index.qmd` must have:

1. **YAML front matter** with required fields: `title`, `categories`, `author`, `date`, `description`.
2. **`{{< include ../../_setup.qmd >}}`** immediately after the front matter — never add `set.seed()` outside of this setup file.
3. **Description**: a single sentence starting with a verb (e.g., "Learn how to...", "Demonstrate...", "Show..."). Do not repeat the title.
4. **Directory naming**: `YYYY-MM-DD-short-description`.
5. **Rendered output**: gallery posts are not re-rendered in CI, so the `mlr-org/_freeze/` output must be included in pull requests.

### Front matter template

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

## R code rules (for gallery post chunks)

- Use `=` for assignment, never `<-`.
- Load packages at the top with `library()`.
- All optional arguments must use named argument syntax.
- Use sugar functions (`lrn()`, `tsk()`, `msr()`, `rsmp()`, `trm()`, `po()`) in prose and main examples, not `$new()` constructors.
- No comments in code chunks — explanations go in surrounding text.
  Exception: very complex code where a brief comment genuinely aids comprehension.
- Do not shadow function names as variable names (e.g., do not name a variable `lrn` or `task`).
  Use descriptive names: `learner`, `task_iris`, `rr`, `bmr`, etc.
- Every code chunk must have accompanying prose explaining what it does and what the output means.
- Double quotes for strings, explicit `TRUE`/`FALSE` (never `T`/`F`), explicit `1L` for integers.

## Chunk naming

Code chunks in gallery posts should follow the pattern `{index}-{number}` (e.g., `index-001`).
The `name-chunk` skill can auto-number unnamed chunks for a given file.

## R helper code style (for `R/*.R`)

The helpers in `R/` are small and internal. Match the existing style:

- Use `=` for assignment, never `<-`.
- 2-space indentation, 120-character line limit.
- `snake_case` for functions and variables.
- Double quotes, explicit `TRUE`/`FALSE`, explicit `1L` for integers.
- Use `checkmate` `assert_*()` for argument checks in user-facing helpers.
- Prefer `result = if (...) ... else ...` over `if/else` blocks that only differ by the assigned value.

## English writing rules

- Do not write "R6" unless explicitly discussing class paradigms.
  Write "The `Learner`..." not "The R6 class `Learner`...".
- No contractions: "do not" not "don't", "cannot" not "can't", "it is" not "it's".
- American English, Oxford comma.
- Use sentence case for headings.
- Do not capitalize normal nouns or method names.
  "Bayesian" is capitalized, "random forest" is not.
- Use `cspell` to check against typos, and add needed words to `.cspell/project-words.txt` if reasonable.

## Quarto and formatting rules

**Inline code formatting:**
- Packages: `` `package` `` (e.g., `` `mlr3` ``)
- Functions with package qualifier: `` `package::function()` ``
- Functions (in-package): `` `function()` ``
- R6 fields: `` `$field` ``
- R6 methods: `` `$method()` ``

**Links and references:**
- API references: use `` `r ref("function()")` `` or `` `r ref("package::function()")` `` for disambiguation.
- Package references: use `` `r ref_pkg("package")` `` for non-mlr3 packages; for mlr3 ecosystem packages use `` `r mlr3` ``, `` `r mlr3tuning` ``, etc. (defined as objects in `R/links.R`).
- Figures: must include alt text.

**Callout boxes — permitted types only:**
- `::: {.callout-warning}` — important exceptions the reader must not miss.
- `::: {.callout-tip}` — optional useful hints, more advanced notes.
- Never use `::: {.callout-note}`, `::: {.callout-important}`, or `::: {.callout-caution}`.

**Numbers in prose:**
- Plain numbers: no formatting (`1`, not `` `1` `` or `$1$`).
- Code values: backticks.
- Mathematical quantities: `$...$`.

## CSS

- Global CSS rules live in `mlr-org/custom.scss`.
- Follow the BEM naming pattern and use SASS.
- The website uses the Bootswatch Yeti theme.

## Bibliography

- References live in `mlr-org/publications.bib`.
- Cite with Quarto's `[@key]` syntax.

## GitHub

- If you use `gh` to retrieve information about an issue, always use `--comments` to read all the comments.

## Proofreading

If the user asks you to proofread a file, act as an expert proofreader and editor with a deep understanding of clear, engaging, and well-structured writing.

Work paragraph by paragraph, always starting by making a TODO list that includes individual items for each top-level heading.

Fix spelling, grammar, and other minor problems without asking the user.
Label any unclear, confusing, or ambiguous sentences with a FIXME comment.

Only report what you have changed.
