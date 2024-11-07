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
#| include: false
future::plan("sequential")
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
# retrieve the task from mlr3
task = tsk("pima")

# create data frame with categorized pressure feature
data = task$data(cols = "pressure")
breaks = quantile(data$pressure, probs = c(0, 0.33, 0.66, 1), na.rm = TRUE)
data$pressure = cut(data$pressure, breaks, labels = c("low", "mid", "high"))

# overwrite the feature in the task
task$cbind(data)

# generate a quick textual overview
skimr::skim(task$data())
#
#
#
#
#
learner = lrn("classif.xgboost", nrounds = 100, id = "xgboost", verbose = 0)
#
#
#
#
#
#
#
round(task$missings() / task$nrow, 2)
#
#
#
#
#
#
#
mlr_pipeops$keys("^impute")
#
#
#
#
#
imputer = po("imputeoor")
print(imputer)
#
#
#
#
#
#
task_imputed = imputer$train(list(task))[[1]]
task_imputed$missings()
#
#
#
#
#
rbind(
  task$data()[8,],
  task_imputed$data()[8,]
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
factor_encoding = po("encode", method = "one-hot")
#
#
#
#
#
factor_encoding$train(list(task))
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
graph = po("encode") %>>%
  po("imputeoor") %>>%
  learner
plot(graph, html = FALSE)
#
#
#
#
#
graph_learner = as_learner(graph)

# short learner id for printing
graph_learner$id = "graph_learner"
#
#
#
#
#
#
#
resampling = rsmp("cv", folds = 3)

rr = resample(task = task, learner = graph_learner, resampling = resampling)
#
#
#
rr$score()[, c("iteration", "task_id", "learner_id", "resampling_id", "classif.ce"), with = FALSE]
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
as.data.table(graph_learner$param_set)[, c("id", "class", "lower", "upper", "nlevels"), with = FALSE]
#
#
#
#
#
graph_learner$param_set$values$encode.method = to_tune(c("one-hot", "treatment"))
#
#
#
#
#
instance = tune(
  tuner = tnr("grid_search"),
  task = task,
  learner = graph_learner,
  resampling = rsmp("cv", folds = 3),
  measure = msr("classif.ce")
)
#
#
#
#
#
print(instance$archive)
#
#
#
#
#
#
#
#
graph_1 = po("encode") %>>%
  learner
graph_learner_1 = GraphLearner$new(graph_1)

graph_learner_1$param_set$values$encode.method = to_tune(c("one-hot", "treatment"))

at_1 = AutoTuner$new(
  learner = graph_learner_1,
  resampling = resampling,
  measure = msr("classif.ce"),
  terminator = trm("none"),
  tuner = tnr("grid_search"),
  store_models = TRUE
)
#
#
#
graph_2 = po("encode") %>>%
  po("imputeoor") %>>%
  learner
graph_learner_2 = GraphLearner$new(graph_2)

graph_learner_2$param_set$values$encode.method = to_tune(c("one-hot", "treatment"))

at_2 = AutoTuner$new(
  learner = graph_learner_2,
  resampling = resampling,
  measure = msr("classif.ce"),
  terminator = trm("none"),
  tuner = tnr("grid_search"),
  store_models = TRUE
)
#
#
#
#
#
resampling_outer = rsmp("cv", folds = 3)
design = benchmark_grid(task, list(at_1, at_2), resampling_outer)

bmr = benchmark(design, store_models = TRUE)
#
#
#
#
#
bmr$aggregate()
autoplot(bmr)
#
#
#
#
#
#
#
#
graph_1 = po("encode") %>>% learner
graph_learner_1 = as_learner(graph_1)
graph_learner_1$param_set$values$encode.method = to_tune(c("one-hot", "treatment"))

at_1 = auto_tuner(
  method = "grid_search",
  learner = graph_learner_1,
  resampling = resampling,
  measure = msr("classif.ce"),
  store_models = TRUE)

graph_2 = po("encode") %>>% po("imputeoor") %>>% learner
graph_learner_2 = as_learner(graph_2)
graph_learner_2$param_set$values$encode.method = to_tune(c("one-hot", "treatment"))

at_2 = auto_tuner(
  method = "grid_search",
  learner = graph_learner_2,
  resampling = resampling,
  measure = msr("classif.ce"),
  store_models = TRUE)

design = benchmark_grid(task, list(at_1, at_2), rsmp("cv", folds = 3))

bmr = benchmark(design, store_models = TRUE)
#
#
#
#
#
#
#
at_2$train(task)
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
