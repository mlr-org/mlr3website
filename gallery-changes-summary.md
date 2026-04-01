## Gallery Post Changes Summary

### API Modernization (`x_domain_*` column removal)

Several posts were updated to remove the now-obsolete `x_domain_*` archive columns, using the direct parameter names instead:

- **`optimization/2021-01-19-integer-hyperparameters`** — Removed `x_domain_k` from archive query and updated surrounding text.
- **`optimization/2021-03-09-practical-tuning-series-tune-a-support-vector-machine`** — Replaced `x_domain_cost`/`x_domain_gamma` with `cost`/`gamma` in archive query and `autoplot()` call.
- **`optimization/2021-03-11-practical-tuning-series-build-an-automated-machine-learning-system`** — Replaced `x_domain_kknn.k`/`x_domain_svm.cost` with `kknn.k`/`svm.cost` in `autoplot()`.
- **`basic/2020-03-11-mlr3tuning-tutorial-german-credit`** — Updated `ggplot` aesthetics from `x_domain_k`/`x_domain_kernel` to `k`/`kernel`; also migrated `TuningInstanceSingleCrit$new()` to `ti()` with `measures =` instead of `measure =`.

### Tuning API Migration (`TuningInstanceSingleCrit` → `ti()`)

- **`pipelines/2021-02-03-tuning-a-complex-graph`** — Replaced `TuningInstanceSingleCrit$new()` with `ti()`, updated `measure` to `measures`, changed `tune_ps2$trafo` to `tune_ps2$extra_trafo`, and updated stale cross-references (`TerminatorNone` → `mlr_terminators_none`, `TunerRandomSearch` → `TunerBatchRandomSearch`).

### Removal of Deprecated `set_row_roles(..., "holdout")`

- **`pipelines/2020-03-12-intro-pipelines-titanic`** — Replaced `task$set_row_roles(892:1309, "holdout")` with `task$filter(1:891)`.
- **`pipelines/2020-04-27-mlr3pipelines-Imputation-titanic`** — Same replacement as above.
- **`basic/2020-05-02-feature-engineering-of-date-time-variables`** — Replaced `task$set_row_roles(validation_set, roles = "holdout")` with `task$filter(setdiff(...))`.

### Removed `caret` Dependency

- **`basic/2020-03-30-stratification-blocking`** — Replaced `caret::createMultiFolds()` with a self-contained `create_multi_folds()` helper function.

### Dataset Replacement (`boston_housing` → `california_housing`)

- **`technical/2022-12-22-mlr3viz`** — All uses of the deprecated `tsk("boston_housing")` dataset were replaced with `tsk("california_housing")`, with feature names updated accordingly (`"age"` → `"median_income"`, `c("age", "rm")` → `c("latitude", "longitude")`).

### Bug Workaround

- **`appliedml/2025-05-05-adv-feature-preproc-filter`** — Commented out a code block that lists compatible filters, adding a note linking to a bug in `mlr3pipelines` ([#985](https://github.com/mlr-org/mlr3pipelines/issues/985)).

### Cleanup & Housekeeping

- **`appliedml/2025-05-07-parallel-parallelization`** — Added `unlink("mlr3_experiments", recursive = TRUE)` before registry creation to avoid stale state, and added a hidden cleanup chunk at the end of the document.
- **`appliedml/2025-06-02-adv-perf-eval-calibration-mlr3-v2`** — Added chunk labels (`index-001` to `index-014`) to all previously unnamed code chunks; added `#| eval: false` to one chunk.
- **`basic/2020-05-04-moneyball`** — Fixed a `DT::datatable()` call that transposed a named numeric vector into a proper two-column `data.table` with `variable` and `importance` columns.
- **`technical/2023-10-25-bart-survival`** — Removed `#| cache: true` from the `resample()` chunk.
- Various posts — Trailing whitespace removed throughout.

### Docker Image Updates (`mlrorg/mlr3-gallery`)

The following R packages were added to the gallery Docker image (`mlr3docker/mlr3gallery/Dockerfile`) to fix missing-package render failures:

- **`bestNormalize`** — Required by `appliedml/2025-04-28-feature-preproc-encoding-scaling`.
- **`GGally`** — Required by several posts using `ggpairs()`.
- **`PMCMRplus`** — Required by `appliedml/2025-05-07-perf-eval-benchmarking-hypothesis`.
- **`mlr3benchmark`** — Required by benchmarking posts.
- **`ggdendro`**, **`ggfortify`** — Required by `technical/2022-12-22-mlr3viz`.
- **`clue`** — Required by `mlr3cluster` learner `clust.kmeans` (used in mlr3viz).

### Infrastructure / Render Maintenance

- **Stale `.quarto/idx` entries removed** — Deleted stale `index.rmarkdown.json` index entries for `pipelines/2020-04-18-regression-chains` and `pipelines/2020-09-11-liver-patient-classification`. These were left over from failed renders and caused Quarto to try rendering non-existent source files.
- **Orphaned `index.rmarkdown` temp files removed** — Deleted leftover `index.rmarkdown` temp files (created by Quarto's knitr bridge during interrupted renders) from `pipelines/2020-02-01-tuning-multiplexer` and `pipelines/2020-09-11-liver-patient-classification`. These were treated as source documents by Quarto, causing phantom render entries.
- **Root-owned render artifacts cleaned up** — Removed `index.html`, `index_files/`, and `index.knit.md` artifacts left behind by parallel renders from 15+ gallery source directories (pipelines, optimization, appliedml posts).
- **Old-style figure filenames removed from freeze** — Deleted stale PNG entries using old chunk-based naming (e.g., `2020-02-01-tuning-multiplexer-006-1.png`) from 5 pipeline posts' freeze directories; replaced by new-style `index-NNN-1.png` names generated by the current Quarto version.
- **Freeze hashes updated** — Pre-rendered all three subdirectories (`gallery/appliedml/`, `gallery/basic/`, `gallery/technical/`) separately to update freeze hashes for 38+ posts that were out of date with the current Quarto version. This prevented `index.knit.md` files from being created and picked up as spurious render targets during the full `quarto render gallery/` run.
