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
#
#| include: false
requireNamespace("e1071")
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
task = tsk("pima")
#
#
#
#
#
#
#
learners = list(
  lrn("classif.kknn", id = "kknn"),
  lrn("classif.svm", id = "svm", type = "C-classification"),
  lrn("classif.ranger", id = "ranger")
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
graph =
  po("branch", options = c("kknn", "svm", "ranger")) %>>%
  gunion(lapply(learners, po)) %>>%
  po("unbranch")
graph$plot(html = FALSE)
#
#
#
#
#
#
learners = list(
  kknn = lrn("classif.kknn", id = "kknn"),
  svm = lrn("classif.svm", id = "svm", type = "C-classification"),
  ranger = lrn("classif.ranger", id = "ranger")
)

graph = ppl("branch", lapply(learners, po))
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
#
#
graph = ppl("robustify", task = task, factors_to_numeric = TRUE) %>>%
  graph
plot(graph, html = FALSE)
#
#
#
#
#
gunion(list(po("imputehist"),
  po("missind", affect_columns = selector_type(c("numeric", "integer"))))) %>>%
  po("featureunion") %>>%
  po("encode") %>>%
  po("removeconstants")
#
#
#
#
#
#
#
graph_learner = as_learner(graph)
#
#
#
#
#
#
#
as.data.table(graph_learner$param_set)[, .(id, class, lower, upper, nlevels)]
#
#
#
#
#
#
#
#
#
# branch
graph_learner$param_set$values$branch.selection =
  to_tune(c("kknn", "svm", "ranger"))

# kknn
graph_learner$param_set$values$kknn.k =
  to_tune(p_int(3, 50, logscale = TRUE, depends = branch.selection == "kknn"))

# svm
graph_learner$param_set$values$svm.cost =
  to_tune(p_dbl(-1, 1, trafo = function(x) 10^x, depends = branch.selection == "svm"))

# ranger
graph_learner$param_set$values$ranger.mtry =
  to_tune(p_int(1, 8, depends = branch.selection == "ranger"))

# short learner id for printing
graph_learner$id = "graph_learner"
#
#
#
#
#
instance = tune(
  tuner = tnr("random_search"),
  task = task,
  learner = graph_learner,
  resampling = rsmp("cv", folds = 3),
  measure = msr("classif.ce"),
  term_evals = 20
)
#
#
#
#
#
#| column: page
autoplot(instance, type = "marginal",
  cols_x = c("x_domain_kknn.k", "x_domain_svm.cost", "ranger.mtry"))
#
#
#
#
#
#
#
learner = as_learner(graph)
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
graph_learner = as_learner(graph)
graph_learner$param_set$values$branch.selection =
  to_tune(c("kknn", "svm", "ranger"))
graph_learner$param_set$values$kknn.k =
  to_tune(p_int(3, 50, logscale = TRUE, depends = branch.selection == "kknn"))
graph_learner$param_set$values$svm.cost =
  to_tune(p_dbl(-1, 1, trafo = function(x) 10^x, depends = branch.selection == "svm"))
graph_learner$param_set$values$ranger.mtry =
  to_tune(p_int(1, 8, depends = branch.selection == "ranger"))
graph_learner$id = "graph_learner"

inner_resampling = rsmp("cv", folds = 3)
at = auto_tuner(
  learner = graph_learner,
  resampling = inner_resampling,
  measure = msr("classif.ce"),
  terminator = trm("evals", n_evals = 10),
  tuner = tnr("random_search")
)

outer_resampling = rsmp("cv", folds = 3)
rr = resample(task, at, outer_resampling, store_models = TRUE)
#
#
#
#
#
#
#
#
extract_inner_tuning_results(rr)
#
#
#
#| column: page
DT::datatable(extract_inner_tuning_results(rr)[, .SD, .SDcols = !c("learner_param_vals", "x_domain")])
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
rr$aggregate()
#
#
#
#
#
graph_learner = as_learner(graph)
graph_learner$param_set$values$branch.selection =
  to_tune(c("kknn", "svm", "ranger"))
graph_learner$param_set$values$kknn.k =
  to_tune(p_int(3, 50, logscale = TRUE, depends = branch.selection == "kknn"))
graph_learner$param_set$values$svm.cost =
  to_tune(p_dbl(-1, 1, trafo = function(x) 10^x, depends = branch.selection == "svm"))
graph_learner$param_set$values$ranger.mtry =
  to_tune(p_int(1, 8, depends = branch.selection == "ranger"))
graph_learner$id = "graph_learner"

rr = tune_nested(
  tuner = tnr("random_search"),
  task = task,
  learner = graph_learner,
  inner_resampling = rsmp("cv", folds = 3),
  outer_resampling = rsmp("cv", folds = 3),
  measure = msr("classif.ce"),
  term_evals = 10,
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
