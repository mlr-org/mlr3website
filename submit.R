library(mlr3)
library(mlr3learners)
library(mlr3tuning)
library(mlr3tuningspaces)
library(mlr3pipelines)
library(dplyr)
library(mlr3mbo)


train = read.csv("train.csv")
task = as_task_classif(train, target = "Survived", positive = "1")

library("stringi")
po_ftextract = po("mutate", mutation = list(
  fare_per_person = ~ Fare / (Parch + SibSp + 1),
  deck = ~ factor(stri_sub(Cabin, 1, 1)),
  title = ~ factor(stri_match(Name, regex = ", (.*)\\.")[, 2]),
  surname = ~ factor(stri_match(Name, regex = "(.*),")[, 2]),
  ticket_prefix = ~ factor(stri_replace_all_fixed(stri_trim(stri_match(Ticket, regex = "(.*) ")[, 2]), ".", ""))
))

po_indicator = po("missind",
                  affect_columns = selector_type(c("numeric", "integer")), type = "numeric")


# random forest
learner = lts(lrn("classif.ranger"))
graph_rf = po_ftextract %>>%
  po("collapsefactors", param_vals = list(no_collapse_above_prevalence = 0.03)) %>>%
  po("select", param_vals = list(selector = selector_invert(selector_type("character")))) %>>%
  gunion(list(po_indicator, po("imputehist"))) %>>%
  po("featureunion") %>>%
  po("imputeoor") %>>%
  po("fixfactors") %>>%
  po("imputesample") %>>%
  learner

graph_learner_rf = as_learner(graph_rf)

at_rf = auto_tuner(
  learner = graph_learner_rf,
  resampling = rsmp("cv", folds = 3),
  measure = msr("classif.acc"),
  terminator = trm("evals", n_evals = 100),
  tuner = tnr("mbo")
)



# xgboost
learner = lts(lrn("classif.xgboost"))
graph_xgb =  po_ftextract %>>%
  po("encode", method = "one-hot") %>>%
  po("collapsefactors", param_vals = list(no_collapse_above_prevalence = 0.03)) %>>%
  po("select", param_vals = list(selector = selector_invert(selector_type("character")))) %>>%
  gunion(list(po_indicator, po("imputehist"))) %>>%
  po("featureunion") %>>%
  po("imputeoor") %>>%
  po("fixfactors") %>>%
  po("imputesample") %>>%
  learner
graph_learner_xgb = as_learner(graph_xgb)

at_xgb = auto_tuner(
  learner = graph_learner_xgb,
  resampling = rsmp("cv", folds = 3),
  measure = msr("classif.acc"),
  terminator = trm("evals", n_evals = 100),
  tuner = tnr("mbo")
)



# svm
learner = lts(lrn("classif.svm", type = "C-classification"))
graph_svm =  po_ftextract %>>%
  po("encode", method = "one-hot") %>>%
  po("collapsefactors", param_vals = list(no_collapse_above_prevalence = 0.03)) %>>%
  po("select", param_vals = list(selector = selector_invert(selector_type("character")))) %>>%
  gunion(list(po_indicator, po("imputehist"))) %>>%
  po("featureunion") %>>%
  po("imputeoor") %>>%
  po("fixfactors") %>>%
  po("imputesample") %>>%
  learner
graph_learner_svm = as_learner(graph_svm)
at_svm = auto_tuner(
  learner = graph_learner_svm,
  resampling = rsmp("cv", folds = 3),
  measure = msr("classif.acc"),
  terminator = trm("evals", n_evals = 100),
  tuner = tnr("mbo")
)



# benchmarking
rsmp_cv5 = rsmp("cv", folds = 3)
learners = list(at_rf, at_xgb, at_svm)
design = benchmark_grid(task, learners, rsmp_cv5)
bm = benchmark(design)
bm$aggregate(msr("classif.acc"))
