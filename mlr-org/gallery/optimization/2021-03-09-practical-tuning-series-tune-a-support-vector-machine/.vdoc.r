#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
requireNamespace("DiceKriging")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
library(mlr3verse)
#
#
#
#
#
#
#
set.seed(7832)
lgr::get_logger("mlr3")$set_threshold("warn")
lgr::get_logger("bbotk")$set_threshold("warn")
#
#
#
#
#
#
#
#
#
# retrieve the task from mlr3
task = tsk("iris")

# generate a quick textual overview using the skimr package
skimr::skim(task$data())
#
#
#
#
#
learner = lrn("classif.svm", type = "C-classification", kernel = "radial")
#
#
#
#
#
#
#
#
#
#
as.data.table(learner$param_set)[, .(id, class, lower, upper, nlevels)]
#
#
#
#
#
#
learner$param_set$values$cost = to_tune(0.1, 10)
learner$param_set$values$gamma = to_tune(0, 5)
#
#
#
#
#
#
#
#
resampling = rsmp("cv", folds = 3)
measure = msr("classif.ce")
#
#
#
#
#
#
#
#
terminator = trm("none")
#
#
#
#
#
instance = ti(
  task = task,
  learner = learner,
  resampling = resampling,
  measure = measure,
  terminator = terminator
)

print(instance)
#
#
#
#
#
#
#
#
#
tuner = tnr("grid_search", resolution = 5)

print(tuner)
#
#
#
#
#
generate_design_grid(learner$param_set$search_space(), resolution = 5)
#
#
#
#
#
tuner$optimize(instance)
#
#
#
#
#
autoplot(instance, type = "surface", cols_x = c("cost", "gamma"),
  learner = lrn("regr.km"))
#
#
#
# regr.km prints a log
log = capture.output(autoplot(instance, type = "surface", cols_x = c("cost", "gamma"), learner = lrn("regr.km")))
#
#
#
#
#
#
#
#
#
learner = lrn("classif.svm", type = "C-classification", kernel = "radial")
learner$param_set$values$cost = to_tune(0.1, 10)
learner$param_set$values$gamma = to_tune(0, 5)

instance = tune(
  tuner = tnr("grid_search", resolution = 5),
  task = tsk("iris"),
  learner = learner,
  resampling = rsmp ("holdout"),
  measure = msr("classif.ce")
)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
learner = lrn("classif.svm", type = "C-classification", kernel = "radial")

# tune from 2^-15 to 2^15 on a log scale
learner$param_set$values$cost = to_tune(p_dbl(-15, 15, trafo = function(x) 2^x))

# tune from 2^-15 to 2^5 on a log scale
learner$param_set$values$gamma = to_tune(p_dbl(-15, 5, trafo = function(x) 2^x))
#
#
#
#
#
#
#
learner$param_set$values$cost = to_tune(p_dbl(1e-5, 1e5, logscale = TRUE))
learner$param_set$values$gamma = to_tune(p_dbl(1e-5, 1e5, logscale = TRUE))
#
#
#
#
#
instance = tune(
  tuner = tnr("grid_search", resolution = 5),
  task = task,
  learner = learner,
  resampling = resampling,
  measure = measure
)
#
#
#
#
#
#
#
as.data.table(instance$archive)[, .(cost, gamma, x_domain_cost, x_domain_gamma)]
#
#
#
#
#
library(ggplot2)
library(scales)
autoplot(instance, type = "points", cols_x = c("x_domain_cost", "x_domain_gamma")) +
  scale_x_continuous(
    trans = log2_trans(),
    breaks = trans_breaks("log10", function(x) 10^x),
    labels = trans_format("log10", math_format(10^.x))) +
  scale_y_continuous(
    trans = log2_trans(),
    breaks = trans_breaks("log10", function(x) 10^x),
    labels = trans_format("log10", math_format(10^.x)))
#
#
#
#
#
#
#
#
learner = lrn("classif.svm", type = "C-classification")

learner$param_set$values$cost = to_tune(p_dbl(1e-5, 1e5, logscale = TRUE))
learner$param_set$values$gamma = to_tune(p_dbl(1e-5, 1e5, logscale = TRUE))

learner$param_set$values$kernel = to_tune(c("polynomial", "radial"))
learner$param_set$values$degree = to_tune(1, 4)
#
#
#
#
#
learner$param_set$deps
#
#
#
#
#
learner$param_set$deps$cond[[5]]
#
#
#
#
#
learner$param_set$deps$cond[[3]]
#
#
#
#
#
generate_design_grid(learner$param_set$search_space(), resolution = 2)
#
#
#
#
#
#
#
instance = tune(
  tuner = tnr("grid_search", resolution = 3),
  task = task,
  learner = learner,
  resampling = resampling,
  measure = measure
)
#
#
#
instance$result
#
#
#
#
#
#
#
learner = lrn("classif.svm")
learner$param_set$values = instance$result_learner_param_vals
learner$train(task)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
learner = lrn("classif.svm", type = "C-classification")
learner$param_set$values$cost = to_tune(p_dbl(1e-5, 1e5, logscale = TRUE))
learner$param_set$values$gamma = to_tune(p_dbl(1e-5, 1e5, logscale = TRUE))
learner$param_set$values$kernel = to_tune(c("polynomial", "radial"))
learner$param_set$values$degree = to_tune(1, 4)

resampling_inner = rsmp("cv", folds = 3)
terminator = trm("none")
tuner = tnr("grid_search", resolution = 3)

at = auto_tuner(
  learner = learner,
  resampling = resampling_inner,
  measure = measure,
  terminator = terminator,
  tuner = tuner,
  store_models = TRUE)
#
#
#
#
#
resampling_outer = rsmp("cv", folds = 3)
rr = resample(task = task, learner = at, resampling = resampling_outer, store_models = TRUE)
#
#
#
#
#
#
#
#
#| column: page
extract_inner_tuning_results(rr)[, .SD, .SDcols = !c("learner_param_vals", "x_domain")]
#
#
#
#
#
#
rr$score()[, .(iteration, task_id, learner_id, resampling_id, classif.ce)]
#
#
#
#
#
#| column: page
extract_inner_tuning_archives(rr, unnest = NULL, exclude_columns = c("resample_result", "uhash", "x_domain", "timestamp"))
#
#
#
#
#
rr$aggregate()
#
#
#
#
#
learner = lrn("classif.svm", type = "C-classification")
learner$param_set$values$cost = to_tune(p_dbl(1e-5, 1e5, logscale = TRUE))
learner$param_set$values$gamma = to_tune(p_dbl(1e-5, 1e5, logscale = TRUE))
learner$param_set$values$kernel = to_tune(c("polynomial", "radial"))
learner$param_set$values$degree = to_tune(1, 4)

rr = tune_nested(
  tuner = tnr("grid_search", resolution = 3),
  task = tsk("iris"),
  learner = learner,
  inner_resampling = rsmp ("cv", folds = 3),
  outer_resampling = rsmp("cv", folds = 3),
  measure = msr("classif.ce"),
)
#
#
#
#
#
#
#
#
#
#
#
