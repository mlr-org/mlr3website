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
