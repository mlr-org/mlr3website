
library(mlr3oml)
library(mlr3hyperband)
library(mlr3pipelines)
library(mlr3learners)
library(mlr3tuningspaces)

future::plan("multicore", workers = 10)

# custom balanced accuracy eval metric
eval_metric = function(preds, dtrain) {
  nlvls = length(unique(xgboost::getinfo(dtrain, "label")))
  mat = matrix(preds, ncol = nlvls, byrow = TRUE)
  response = factor(max.col(mat), levels = seq(nlvls))
  truth = factor(xgboost::getinfo(dtrain, "label") + 1, levels = seq(nlvls))
  bacc = mlr3measures::bacc(truth, response)
  list(metric = "bacc", value = bacc)
}

callback = callback_tuning("custom.early_stopping",
  label = "Early Stopping Callback",
  on_optimization_begin = function(callback, context) {
    # store models temporary
    context$instance$objective$store_models = TRUE
  },

  on_eval_after_benchmark = function(callback, context) {
    callback$state$max_nrounds = mlr3misc::map_dbl(context$benchmark_result$resample_results$resample_result, function(rr) {
        max(mlr3misc::map_dbl(mlr3misc::get_private(rr)$.data$learner_states(mlr3misc::get_private(rr)$.view), function(state) {
          state$model$xgboost$model$best_iteration
        }))
    })
  },

  on_eval_before_archive = function(callback, context) {
    data.table::set(context$aggregated_performance, j = "max_nrounds", value = callback$state$max_nrounds)
    context$benchmark_result$discard(models = TRUE)
  },

  on_result = function(callback, context) {
    context$result$learner_param_vals[[1]]$nrounds = context$instance$archive$best()$max_nrounds
    context$instance$objective$store_models = FALSE
  }
)

learner = lts(lrn("classif.xgboost",
  objective = "multi:softprob",
  eval_metric = eval_metric,
  maximize = TRUE,
  early_stopping_rounds = 100,
  early_stopping_set = "test",
  timeout = c(train = 25200, predict = Inf),
  encapsulate = c(train = "callr", predict = "callr"),
  fallback = lrn("classif.featureless"),
  nthread = 4,
  predict_type = "prob"))

learner$id = "xgboost"

learner = as_learner(po("subsample", stratify = TRUE) %>>% learner)

learner$param_set$set_values(xgboost.nrounds = 1000, subsample.frac = to_tune(p_dbl(lower = 3^-3, upper = 1, tags = "budget")))

# covertype
task = tsk("oml", data_id = 1596)
task = po("encode", method = "one-hot")$train(list(task))[[1]]
task$col_roles$stratum = task$target_names

# ensure the same resampling splits for all optimizers
resampling = rsmp("cv", folds = 3)
resampling$instantiate(task)

instance = TuningInstanceSingleCrit$new(
  task = task,
  learner = learner,
  resampling = resampling,
  measure = msr("classif.bacc"),
  terminator = trm("run_time", secs = 3600 * 24),
  check_values = FALSE,
  store_benchmark_result = FALSE,
  store_models = FALSE,
  callbacks = callback
)

tuner = tnr("hyperband", eta = 3, repetitions = Inf)

tuner$optimize(instance)

saveRDS(instance, "instance.rds")


